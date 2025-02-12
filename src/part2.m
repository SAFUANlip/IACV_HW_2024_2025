%% Euclidean rectification of horizontal plane 
close all
clearvars
clc

%% load an image of a plane
im = imread("/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/images/Look-outCat.jpg");
%im = imresize(im);

A_point = [402.1181 249.3789 1]';
B_point = [463.7551 455.0959 1]';
C_point = [719.1842 470.9011 1]';
D_point = [775.7712 297.2566 1]';
E_point = [331.6935 691.2217 1]';
F_point = [802.1764 689.3995 1]';

lab = cross(A_point, B_point);
ldc = cross(D_point, C_point);
lad = cross(A_point, D_point);
lbc = cross(B_point, C_point);

v1 = cross(lab, ldc);
v1 = v1/v1(3);
v2 = cross(lad, lbc);
v2 = v2/v2(3);

vline = cross(v1, v2);
vline = vline/vline(3);

%%
H = [eye(2), zeros(2,1); vline(:)'];

fprintf("The vanishing line mapped to\n");
disp(inv(H)'*vline)

%% Getting ellipse
figure;
imshow(im);
hold all;
do_load_annotations = 1;

if do_load_annotations
    if isfile("HW/colander.mat")
        data = load("HW/colander.mat");
        ellipse1 = data.ellipse1;
    else
        error('Did not find file with ellipse!');
    end

    % Uploading ellipse
    ellipse1 = drawellipse('Center', ellipse1.Center, ...
                           'SemiAxes', ellipse1.SemiAxes, ...
                           'RotationAngle', ellipse1.RotationAngle);
else
    % Drawing new ellipse
    ellipse1 = drawellipse();

    % Saving ellipse
    ellipse1.Center = ellipse1.Center;
    ellipse1.SemiAxes = ellipse1.SemiAxes;
    ellipse1.RotationAngle = ellipse1.RotationAngle;
end

%% Saving ellipse in file
if (do_load_annotations==0)
    save('HW/colander.mat','ellipse1');
end

%% Convert ellipses into conic matrices
par_geo = [ellipse1.Center, ellipse1.SemiAxes,-ellipse1.RotationAngle]';
par_alg = conic_param_geo2alg(par_geo);
[a1, b1, c1, d1, e1, f1] = deal(par_alg(1),par_alg(2),par_alg(3),par_alg(4),par_alg(5),par_alg(6));
C1=[a1 b1/2 d1/2; b1/2 c1 e1/2; d1/2 e1/2 f1];
C1 = C1./C1(3,3);
% sanity check
im_err = zeros(size(im,1),size(im,2));
for i = 1:size(im,1)
    for j = 1:size(im,2)
        im_err(i,j) = [j,i,1]*C1*[j;i;1];
    end
end

% visual sanity check
lambda = 0.5;
figure;
imshow(lambda*im+(1-lambda)*uint8(255.*(im_err<0)));

%% intersect ellipse with the vanishing line
% see golub for altenative solutions

syms 'x';
syms 'y';

% every conic provide a 2nd degree equation
eq1 = a1*x^2 + b1*x*y + c1*y^2 + d1*x + e1*y + f1;
eq2 = vline(1)*x + vline(2)*y+ vline(3);
% solve a system with a line and the conic: this gives a 2th degree equation
eqns = [eq1 == 0, eq2 == 0];
S12 = solve(eqns, [x,y], 'IgnoreAnalyticConstraints',true,'Maxdegree',4);
% hence you get 2 pairs of complex conjugate solution
s1 = [double(S12.x(1)); double(S12.y(1)); 1];
s2 = [double(S12.x(2)); double(S12.y(2)); 1];

% image of the circular points
II = s1;
JJ = s2;

%% Conic dual to circular points
% compute the image of the dual conic to principal points

imDCCP = II*JJ' + JJ*II';
%imDCCP = imDCCP./norm(imDCCP);

%% extract the line at infinity

l_inf = null(imDCCP);
% II and JJ passes through the line at infinity by construction
II'*l_inf
JJ'*l_inf

% they actually coincide with the solution retrieved before
l_inf - vline


H = [eye(2),zeros(2,1); l_inf(:)'];
tform = projective2d(H');
J = imwarp(im,tform);
figure;
imshow(J);

%% compute the rectifying homography
%[U,D,V] = svd(imDCCP);
[V,D] = eigs(imDCCP) % eigen vectros and eigen values
% sort the eigenvalue
[d,ind] = sort(abs(diag(D)),'descend');
Ds = D(ind, ind);
Vs = V(:,ind);

D

% has a negative eigenvalue!!! We cannot use it to extract the rectifying
% homography :(

% D(1,1) = 1/sqrt(D(1,1))
% D(2,2) = 1/sqrt(D(2,2))
% D(3,3) = 1
% 
% H_sr = D*U'

%% However we have a circle 
% so we can distil metric information
% let's use the information that the axis of the ellipses should be equal
% transform the conic in the rectified plane according to the rule
% C = H^-t C H^-1

Q = inv(H)'*C1*inv(H);
Q = Q./Q(3,3);

%% convert the conic coefficient to geometric parameters
% Ax^2 + Bxy + Cy^2 +Dx + Ey + F = 0
par_geo = AtoG([Q(1,1), 2*Q(1,2), Q(2,2), 2*Q(1,3), 2*Q(2,3), Q(3,3)]);
center = par_geo(1:2);
axes = par_geo(3:4);
angle = par_geo(5);

%% Now we can compute the affinity that make the axis of the ellipses to be equal.
% The affinity is composed by a rotation a scaling and the inverse rotation
alpha = angle;
a = axes(1);
b = axes(2);

% rotation
U = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];

% rescaling the axis to be unitary
S = diag([1, a/b]);
K = U*S*U';
H_metric = [K zeros(2,1); zeros(1,2), 1];
T = H_metric*H; % the final transformation is the composition between the homography that maps the image of the line at infinity to its canonical position and the rescaling

%%
% projective

tform = projective2d(T');
J = imwarp(im, tform, 'OutputView', imref2d(size(im)));
figure;
imshow(J);
title('Metric rectification.')
hold on;

A_aff = T*A_point;
A_aff = A_aff/A_aff(3);

B_aff = T*B_point;
B_aff = B_aff/B_aff(3);

D_aff = T*D_point;
D_aff = D_aff/D_aff(3);

C_aff = T*C_point;
C_aff = C_aff/C_aff(3);

FNT_SZ = 20;
text(A_aff(1), A_aff(2), 'A', 'FontSize', FNT_SZ, 'Color', 'b');
plot(A_aff(1), A_aff(2), '.b', 'MarkerSize', 8);

text(B_aff(1), B_aff(2), 'B', 'FontSize', FNT_SZ, 'Color', 'b');
plot(B_aff(1), B_aff(2), '.b', 'MarkerSize', 8);

text(D_aff(1), D_aff(2), 'D', 'FontSize', FNT_SZ, 'Color', 'b');
plot(D_aff(1), D_aff(2), '.b', 'MarkerSize', 8);

text(C_aff(1), C_aff(2), 'C', 'FontSize', FNT_SZ, 'Color', 'b');
plot(C_aff(1), C_aff(2), '.b', 'MarkerSize', 8);


%% Verifying that corresponding lines still parallel
ab_aff = cross(A_aff, B_aff);
ab_aff = ab_aff/ab_aff(3);

dc_aff = cross(D_aff, C_aff);
dc_aff = dc_aff/dc_aff(3);

ad_aff = cross(A_aff, D_aff);
ad_aff = ad_aff/ad_aff(3);

bc_aff = cross(B_aff, C_aff);
bc_aff = bc_aff/bc_aff(3);

% Extract direction vectors of the lines
vad = ad_aff(1:2);  % Direction vector of ad_aff (from coefficients a and b)
vdc = dc_aff(1:2);  % Direction vector of dc_aff
vab = ab_aff(1:2);  % Direction vector of ab_aff
vbc = bc_aff(1:2);  % Direction vector of bc_aff

% Normalize the vectors to unit length
vad = vad / norm(vad);
vdc = vdc / norm(vdc);
vab = vab / norm(vab);
vbc = vbc / norm(vbc);

theta_deg_ab_dc = rad2deg(acos(dot(vab, vdc)));
theta_deg_ad_bc = rad2deg(acos(dot(vad, vbc)));
theta_deg_ad_ab = rad2deg(acos(dot(vad, vab)));
theta_deg_ab_bc = rad2deg(acos(dot(vab, vbc)));

disp(['Angle between AB and DC after affine transform: ', num2str(theta_deg_ab_dc), ' degrees']);
disp(['Angle between AD and BC after affine transform: ', num2str(theta_deg_ad_bc), ' degrees']);
disp(['Angle between AD and AB after affine transform: ', num2str(theta_deg_ad_ab), ' degrees']);
disp(['Angle between AB and BC after affine transform: ', num2str(theta_deg_ab_bc), ' degrees']);

%% compute depth of parallelepiped
% taking into account that length of whole furniture is 1
% then length of AD and BC is 1/3
length_ad_pixels = sqrt((A_aff(1) - D_aff(1))^2 + (A_aff(2) - D_aff(2))^2);
length_ab_pixels = sqrt((A_aff(1) - B_aff(1))^2 + (A_aff(2) - B_aff(2))^2);

length_ad_real = 1/3;
length_ab_real = length_ab_pixels/length_ad_pixels*length_ad_real;

disp(['Depth of parallepiped (AB): ', num2str(length_ab_real)]);


