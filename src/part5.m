%% Curve S
close all
clearvars
clc

%%
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/');
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/ellipse_functions/');


%% load an image of a plane
im = imread("/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/images/Look-outCat.jpg");
%im = imresize(im);

A_point = [402.1181 249.3789 1]';
B_point = [463.7551 455.0959 1]';
C_point = [719.1842 470.9011 1]';
D_point = [775.7712 297.2566 1]';
E_point = [331.6935 691.2217 1]';
F_point = [802.1764 689.3995 1]';

H_point = [1087.68 344.276 1]';
G_point = [1171.54 685.682 1]';
M_point = [942.498 488.257 1]';
R_point = [721.389 541.479 1]';
N_point = [945.094 513.589 1]';

lad = cross(A_point, D_point);
lef = cross(E_point, F_point);
lae = cross(A_point, E_point);
ldf = cross(D_point, F_point);

lab = cross(A_point, B_point);
ldc = cross(D_point, C_point);
lbc = cross(B_point, C_point);

Hr = [
    1.4888,   -0.7169,         0;
   -0.7169,    2.0515,         0;
   -0.0001,   -0.0011,    1.0000;
    ];

Hv = [
    -0.999883942983777, -0.015230651846324, -3.575018207693751e-04;
    0.026556379446092, -1.743434371814285, 9.637491760607269e-04;
    -3.658786395209837e-04, 5.472144926706133e-04, 1;
    ];

K = [
    708.4832,         0,  813.9804;
         0,  766.1626,  563.7740;
         0,         0,    1.0000;
    ];

%%
figure;
imshow(im);
hold on;

FNT_SZ = 20;
text(A_point(1), A_point(2), 'A', 'FontSize', FNT_SZ, 'Color', 'b');
plot(A_point(1), A_point(2), '.b', 'MarkerSize', 8);
text(B_point(1), B_point(2), 'B', 'FontSize', FNT_SZ, 'Color', 'b');
plot(B_point(1), B_point(2), '.b', 'MarkerSize', 8);
text(C_point(1), C_point(2), 'C', 'FontSize', FNT_SZ, 'Color', 'b');
plot(C_point(1), C_point(2), '.b', 'MarkerSize', 8);
text(D_point(1), D_point(2), 'D', 'FontSize', FNT_SZ, 'Color', 'b');
plot(D_point(1), D_point(2), '.b', 'MarkerSize', 8);
text(E_point(1), E_point(2), 'E', 'FontSize', FNT_SZ, 'Color', 'b');
plot(E_point(1), E_point(2), '.b', 'MarkerSize', 8);
text(F_point(1), F_point(2), 'F', 'FontSize', FNT_SZ, 'Color', 'b');
plot(F_point(1), F_point(2), '.b', 'MarkerSize', 8);
text(H_point(1), H_point(2), 'H', 'FontSize', FNT_SZ, 'Color', 'b');
plot(H_point(1), H_point(2), '.b', 'MarkerSize', 8);
text(G_point(1), G_point(2), 'G', 'FontSize', FNT_SZ, 'Color', 'b');
plot(G_point(1), G_point(2), '.b', 'MarkerSize', 8);
text(M_point(1), M_point(2), 'M', 'FontSize', FNT_SZ, 'Color', 'b');
plot(M_point(1), M_point(2), '.b', 'MarkerSize', 8);
text(R_point(1), R_point(2), 'R', 'FontSize', FNT_SZ, 'Color', 'b');
plot(R_point(1), R_point(2), '.b', 'MarkerSize', 8);
text(N_point(1), N_point(2), 'N', 'FontSize', FNT_SZ, 'Color', 'b');
plot(N_point(1), N_point(2), '.b', 'MarkerSize', 8);

%% Getting ellipse
figure;
imshow(im);
hold all;
do_load_annotations = 1;

if do_load_annotations
    if isfile("HW/ellipseS.mat")
        data = load("HW/ellipseS.mat");
        ellipse2 = data.ellipse2;
    else
        error('Did not find file with ellipse!');
    end

    % Uploading ellipse
    ellipse2 = drawellipse('Center', ellipse2.Center, ...
                           'SemiAxes', ellipse2.SemiAxes, ...
                           'RotationAngle', ellipse2.RotationAngle);
else
    % Drawing new ellipse
    ellipse2 = drawellipse();

    % Saving ellipse
    ellipse2.Center = ellipse2.Center;
    ellipse2.SemiAxes = ellipse2.SemiAxes;
    ellipse2.RotationAngle = ellipse2.RotationAngle;
end

%% Saving ellipse in file
if (do_load_annotations==0)
    save('HW/ellipseS.mat','ellipse2');
end

%% Applying vertical rectification to define middle of HG and DF
tform_hor = projective2d(Hr');
hor_rect = imwarp(im, tform_hor);

tform_vert = projective2d(Hv');
hor_vert = imwarp(im, tform_vert);

D_vert = Hv*D_point;
F_vert = Hv*F_point;
H_vert = Hv*H_point;
G_vert = Hv*G_point;

DF_middle_vert = (D_vert + F_vert)/2;
HG_middle_vert = (H_vert + G_vert)/2;

DF_middle = inv(Hv)*DF_middle_vert;
HG_middle = inv(Hv)*HG_middle_vert;

K_point = DF_middle; % middle of HG line
P_point = HG_middle; % middle of DF line

%%
% Define middle of CDF plane, parallel to CD
C_hor = Hr * C_point;
D_hor = Hr * D_point;
F_hor = Hr * F_point;
H_hor = Hr * H_point;
M_hor = Hr * M_point;
N_hor = Hr * N_point;
R_hor = Hr * R_point;

K_hor = Hr * K_point;
P_hor = Hr * P_point;

C_hor = C_hor / C_hor(3);
D_hor = D_hor / D_hor(3);
F_hor = F_hor / F_hor(3);
H_hor = H_hor / H_hor(3);
M_hor = M_hor / M_hor(3);
N_hor = N_hor / N_hor(3);
R_hor = R_hor / R_hor(3);
K_hor = K_hor / K_hor(3);
P_hor = P_hor / P_hor(3);

%% Define background middle point 
m1 = (R_hor(2) - C_hor(2)) / (R_hor(1) - C_hor(1)); % Line C_hor-R_hor
m2 = (D_hor(2) - C_hor(2)) / (D_hor(1) - C_hor(1)); % Line C_hor-D_hor (parallel to DF_middle_hor line)

% Intercepts of the lines
b1 = C_hor(2) - m1 * C_hor(1); % Intercept for line C_hor-R_hor
b2 = K_hor(2) - m2 * K_hor(1); % Intercept for line parallel to C_hor-D_hor

% Intersection point
x_intersect = (b2 - b1) / (m1 - m2);
y_intersect = m1 * x_intersect + b1;

% Result
R_int_hor = [x_intersect; y_intersect; 1]; % Homogeneous coordinates

R_int_point = inv(Hr)*R_int_hor;
R_int_point = R_int_point / R_int_point(3);

%% Define background middle point 
% Slope of the line M_hor-N_hor
m1 = (N_hor(2) - M_hor(2)) / (N_hor(1) - M_hor(1)); % Line M_hor-N_hor

% Slope of the line parallel to M_hor-H_hor (through HG_middle_hor)
m2 = (H_hor(2) - M_hor(2)) / (H_hor(1) - M_hor(1)); % Line M_hor-H_hor

% Intercepts of the lines
b1 = M_hor(2) - m1 * M_hor(1); % Intercept for line M_hor-N_hor
b2 = P_hor(2) - m2 * P_hor(1); % Intercept for line through HG_middle_hor, parallel to M_hor-H_hor

% Intersection point
x_intersect = (b2 - b1) / (m1 - m2);
y_intersect = m1 * x_intersect + b1;

% Result in homogeneous coordinates
N_int_hor = [x_intersect; y_intersect; 1];

% Transform back to the original plane
N_int_point = inv(Hr) * N_int_hor;
N_int_point = N_int_point / N_int_point(3); % Normalize

%%
lkr_int = cross(K_point, R_int_point);
lpn_int = cross(P_point, N_int_point);
lkp = cross(K_point, P_point);
lrn_int = cross(R_int_point, N_int_point);

v1_hor = cross(lkr_int, lpn_int);
v2_hor = cross(lkp, lrn_int);
v1_hor = v1_hor/v1_hor(3);
v2_hor = v2_hor/v2_hor(3);

vline_hor = cross(v1_hor, v2_hor);
vline_hor = vline_hor/vline_hor(3);

%%
figure;
imshow(im);
hold on;

FNT_SZ = 20;

text(K_point(1), K_point(2), 'K', 'FontSize', FNT_SZ, 'Color', 'r');
plot(K_point(1), K_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');
text(P_point(1), P_point(2), 'P', 'FontSize', FNT_SZ, 'Color', 'r');
plot(P_point(1), P_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');

text(R_int_point(1), R_int_point(2), 'R int', 'FontSize', FNT_SZ, 'Color', 'r');
plot(R_int_point(1), R_int_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');
text(N_int_point(1), N_int_point(2), 'N int', 'FontSize', FNT_SZ, 'Color', 'r');
plot(N_int_point(1), N_int_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');

plot([K_point(1), v1_hor(1)], [K_point(2), v1_hor(2)], 'r');
plot([P_point(1), v1_hor(1)], [P_point(2), v1_hor(2)], 'r');

plot([K_point(1), v2_hor(1)], [K_point(2), v2_hor(2)], 'b');
plot([R_int_point(1), v2_hor(1)], [R_int_point(2), v2_hor(2)], 'b');

plot([v1_hor(1), v2_hor(1)], [v1_hor(2), v2_hor(2)], 'b--')
text(v1_hor(1), v1_hor(2), 'v1 Horizon', 'FontSize', FNT_SZ, 'Color', 'r')
plot(v1_hor(1), v1_hor(2), '.b', 'MarkerSize', 8, 'Color', 'r');
text(v2_hor(1), v2_hor(2), 'v2 Horizon', 'FontSize', FNT_SZ, 'Color', 'b')
plot(v2_hor(1), v2_hor(2), '.b', 'MarkerSize', 8, 'Color', 'b');

hold off

%%

% image of the absolute conic through the calibration matrix K
w = inv(K * K');

% setting the system variables
syms 'x';
syms 'y';

% a  b/2  d/2
% b/2  c  e/2
% d/w  e/2  f
% ax^2 + bxy + cy^2 + dx + ey + f = 0
eq1 = w(1,1)*x^2 + 2*w(1,2)*x*y + w(2,2)*y^2 + 2*w(1,3)*x + 2*w(2,3)*y + w(3,3);

% equation of the image of the line at the infinity
eq2 = vline_hor(1)*x + vline_hor(2) * y + vline_hor(3);

% solving the system
eqns = [eq1 == 0, eq2 == 0];
sol = solve(eqns, [x,y]);

%solutions (image of circular points)
II = [double(sol.x(1)); double(sol.y(1)); 1];
JJ = [double(sol.x(2)); double(sol.y(2)); 1];

% image of dual conic
imDCCP = II*JJ.' + JJ*II.';
imDCCP = imDCCP./norm(imDCCP);

%compute the rectifying homography
[U,D,V] = svd(imDCCP);
[V_eighs, D_eighs] = eigs(imDCCP);

disp('Eigen values: ')
disp(D_eighs)
% no negative eigen values


Hr_hor_mid = [
            1/sqrt(D(1,1)), 0, 0;
            0, 1/sqrt(D(2,2)), 0;
            0,              0, 1;
    ] * U';

% applying the homography to the image
tform = projective2d(Hr_hor_mid');
img_hom_mid = imwarp(im, tform);

img_hom_mid = flip(img_hom_mid, 1); % vertical flip
img_hom_mid = flip(img_hom_mid, 2); % horizontal + vertical flip

%%
% apply rectification for each point 

K_hor_mid = Hr_hor_mid * K_point;
K_hor_mid = K_hor_mid/K_hor_mid(3);

P_hor_mid = Hr_hor_mid * P_point;
P_hor_mid = P_hor_mid/P_hor_mid(3);

N_int_hor_mid = Hr_hor_mid * N_int_point;
N_int_hor_mid = N_int_hor_mid/N_int_hor_mid(3);

R_int_hor_mid = Hr_hor_mid * R_int_point;
R_int_hor_mid = R_int_hor_mid/R_int_hor_mid(3);


% Conic transform
par_geo = [ellipse2.Center, ellipse2.SemiAxes,-ellipse2.RotationAngle]';
par_alg = conic_param_geo2alg(par_geo);
[a1, b1, c1, d1, e1, f1] = deal(par_alg(1),par_alg(2),par_alg(3),par_alg(4),par_alg(5),par_alg(6));
C1=[a1 b1/2 d1/2; b1/2 c1 e1/2; d1/2 e1/2 f1];
C1 = C1./C1(3,3);

C1_hor = inv(Hr_hor_mid') * C1 * inv(Hr_hor_mid);
C1_hor = C1_hor / C1_hor(3,3); % Normalize the transformed conic matrix

% Step 2: Extract geometric parameters from transformed conic
par_alg_hor = [C1_hor(1,1), ...
                2*C1_hor(1,2), ...
                C1_hor(2,2), ...
                2*C1_hor(1,3), ...
                2*C1_hor(2,3), ...
                C1_hor(3,3)]';

% Convert to geometric parameters (center, semi-axes, and rotation)
par_geo_hor = AtoG(par_alg_hor);

% Define ellipse coorindates corresonding to point K
P_hor_mid = P_hor_mid - K_hor_mid;
N_int_hor_mid = N_int_hor_mid - K_hor_mid;
R_int_hor_mid = R_int_hor_mid - K_hor_mid;
par_geo_hor(1:2) = par_geo_hor(1:2) - K_hor_mid(1:2);
K_hor_mid = K_hor_mid - K_hor_mid;

%%
% Direction Vectors 
v1 = R_int_hor_mid(1:2) - K_hor_mid(1:2); % for K_hor_mid - R_int_hor_mid
v2 = P_hor_mid(1:2) - K_hor_mid(1:2); % for K_hor_mid - P_hor_mid

% Ellipse center
C_ellipse = par_geo_hor(1:2);

% projection of ellipse center on  K_hor_mid - R_int_hor_mid
proj_v1 = K_hor_mid(1:2) + (dot(C_ellipse - K_hor_mid(1:2), v1) / norm(v1)^2) * v1;

% part of projection length
length_KR = norm(v1); % length K_hor_mid - R_int_hor_mid
proj_length_v1 = norm(proj_v1 - K_hor_mid(1:2)); % length of projection
ratio_v1 = proj_length_v1 / length_KR;

% projection of ellipse center on K_hor_mid - P_hor_mid
proj_v2 = K_hor_mid(1:2) + (dot(C_ellipse - K_hor_mid(1:2), v2) / norm(v2)^2) * v2;

% length of projection
length_KP = norm(v2); % length of K_hor_mid - P_hor_mid
proj_length_v2 = norm(proj_v2 - K_hor_mid(1:2)); % length of projection
ratio_v2 = proj_length_v2 / length_KP;

% Results
disp('Projection on K_hor_mid - R_int_hor_mid:');
disp(['Coordinates: ', mat2str(proj_v1)]);
disp(['Part of length: ', num2str(ratio_v1)]);

disp('Projection on K_hor_mid - P_hor_mid:');
disp(['Coordinates: ', mat2str(proj_v2)]);
disp(['Part of length: ', num2str(ratio_v2)]);

ellipse_center_real_z = ratio_v1 * 0.33957; % depth of center
ellipse_center_real_y = 0.5 * 0.36288; % height of ellipse center
ellipse_center_real_x = ratio_v2 * 1/3 + 1/3; % length of ellipse center

ellipse_axis_real_length = par_geo_hor(3) * 1/3 / length_KP;
ellipse_axis_real_height = par_geo_hor(4) * 1/3 / length_KP;

ellipse_rotattion = par_geo_hor(5);
%%

% Plot the transformed ellipse and points 
figure;
imshow(img_hom_mid); % Assuming this is the transformed image
hold on;

text(K_hor_mid(1), K_hor_mid(2), 'K', 'FontSize', FNT_SZ, 'Color', 'r');
plot(K_hor_mid(1), K_hor_mid(2), '.b', 'MarkerSize', 8, 'Color', 'r');

text(P_hor_mid(1), P_hor_mid(2), 'P', 'FontSize', FNT_SZ, 'Color', 'r');
plot(P_hor_mid(1), P_hor_mid(2), '.b', 'MarkerSize', 8, 'Color', 'r');

text(N_int_hor_mid(1), N_int_hor_mid(2), 'N\_int', 'FontSize', FNT_SZ, 'Color', 'r');
plot(N_int_hor_mid(1), N_int_hor_mid(2), '.b', 'MarkerSize', 20, 'Color', 'r');

text(R_int_hor_mid(1), R_int_hor_mid(2), 'R\_int', 'FontSize', FNT_SZ, 'Color', 'r');
plot(R_int_hor_mid(1), R_int_hor_mid(2), '.b', 'MarkerSize', 8, 'Color', 'r');

% Draw the scaled ellipse
drawellipse('Center', par_geo_hor(1:2)', ...
            'SemiAxes', par_geo_hor(3:4)', ...
            'RotationAngle', -par_geo_hor(5), ...
            'Color', 'r', 'LineWidth', 2);

title('Middle horizon transform');
hold off;

