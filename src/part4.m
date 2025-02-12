%% Depth of parallelepiped 
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

lad = cross(A_point, D_point);
lef = cross(E_point, F_point);
lae = cross(A_point, E_point);
ldf = cross(D_point, F_point);

lab = cross(A_point, B_point);
ldc = cross(D_point, C_point);
lbc = cross(B_point, C_point);

v1_hor = cross(lab, ldc);
v2_hor = cross(lad, lbc);
v1_hor = v1_hor/v1_hor(3);
v2_hor = v2_hor/v2_hor(3);

vline_hor = cross(v1_hor, v2_hor);
vline_hor = vline_hor/vline_hor(3);

v1_vert = cross(lad, lef);
v1_vert = v1_vert/v1_vert(3);
v2_vert = cross(lae, ldf);
v2_vert = v2_vert/v2_vert(3);

vline_vert = cross(v1_vert, v2_vert);
vline_vert = vline_vert/vline_vert(3);

K = [
    708.4832,         0,  813.9804;
         0,  766.1626,  563.7740;
         0,         0,    1.0000;
    ];

%% plotting vertical lines and vanishing points

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

plot([A_point(1), v1_vert(1)], [A_point(2), v1_vert(2)], 'g');
plot([D_point(1), v1_vert(1)], [D_point(2), v1_vert(2)], 'g');
plot([E_point(1), v1_vert(1)], [E_point(2), v1_vert(2)], 'g');
plot([F_point(1), v1_vert(1)], [F_point(2), v1_vert(2)], 'g');

plot([A_point(1), v2_vert(1)], [A_point(2), v2_vert(2)], 'g');
plot([E_point(1), v2_vert(1)], [E_point(2), v2_vert(2)], 'g');
plot([D_point(1), v2_vert(1)], [D_point(2), v2_vert(2)], 'g');
plot([F_point(1), v2_vert(1)], [F_point(2), v2_vert(2)], 'g');


plot([v1_vert(1), v2_vert(1)], [v1_vert(2), v2_vert(2)], 'b--')
text(v1_vert(1), v1_vert(2), 'v1 Vertical', 'FontSize', FNT_SZ, 'Color', 'g')
text(v2_vert(1), v2_vert(2), 'v2 Vertical', 'FontSize', FNT_SZ, 'Color', 'g')

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
eq2 = vline_vert(1)*x + vline_vert(2) * y + vline_vert(3);

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


H_vert = [
            1/sqrt(D(1,1)), 0, 0;
            0, 1/sqrt(D(2,2)), 0;
            0,              0, 1;
    ] * U';

% applying the homography to the image
tform = projective2d(H_vert');
img_hom = imwarp(im, tform);

img_hom = flip(img_hom, 1); % vertical flip
img_hom = flip(img_hom, 2); % horizontal + vertical flip

%%
fig = figure();
imshow(img_hom), hold on;

A_aff = H_vert*A_point;
A_aff = A_aff/A_aff(3);

D_aff = H_vert*D_point;
D_aff = D_aff/D_aff(3);

E_aff = H_vert*E_point;
E_aff = E_aff/E_aff(3);

F_aff = H_vert*F_point;
F_aff = F_aff/F_aff(3);


FNT_SZ = 20;
text(A_aff(1), A_aff(2), 'A', 'FontSize', FNT_SZ, 'Color', 'b');
plot(A_aff(1), A_aff(2), '.b', 'MarkerSize', 8);

text(D_aff(1), D_aff(2), 'D', 'FontSize', FNT_SZ, 'Color', 'b');
plot(D_aff(1), D_aff(2), '.b', 'MarkerSize', 8);

text(E_aff(1), E_aff(2), 'E', 'FontSize', FNT_SZ, 'Color', 'b');
plot(E_aff(1), E_aff(2), '.b', 'MarkerSize', 8);

text(F_aff(1), F_aff(2), 'F', 'FontSize', FNT_SZ, 'Color', 'b');
plot(F_aff(1), F_aff(2), '.b', 'MarkerSize', 8);

%% compte depth of parallelepiped
% taking into account that length of whole furniture is 1
% then length of AD and BC is 1/3
length_ad_pixels = sqrt((A_aff(1) - D_aff(1))^2 + (A_aff(2) - D_aff(2))^2);
length_df_pixels = sqrt((D_aff(1) - F_aff(1))^2 + (D_aff(2) - F_aff(2))^2);

length_ad_real = 1/3;
length_df_real = length_df_pixels/length_ad_pixels*length_ad_real;

disp(['High of parallepiped (DF): ', num2str(length_df_real)]);


