%% Find vanishing line of horizontal plane
close all
clearvars
clc

%% load an image of a plane
im = imread("/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/images/Look-outCat.jpg");
%im = imresize(im);

A = [402.1181 249.3789 1]';
B = [463.7551 455.0959 1]';
C = [719.1842 470.9011 1]';
D = [775.7712 297.2566 1]';
E = [331.6935 691.2217 1]';
F = [802.1764 689.3995 1]';

H_point = [1087.68 344.276 1]';
G_point = [1171.54 685.682 1]';
M_point = [942.498 488.257 1]';
R_point = [721.389 541.479 1]';
N_point = [945.094 513.589 1]';

%%
figure;
imshow(im);
hold on;

FNT_SZ = 20;
text(A(1), A(2), 'A', 'FontSize', FNT_SZ, 'Color', 'b');
plot(A(1), A(2), '.b', 'MarkerSize', 8);
text(B(1), B(2), 'B', 'FontSize', FNT_SZ, 'Color', 'b');
plot(B(1), B(2), '.b', 'MarkerSize', 8);
text(C(1), C(2), 'C', 'FontSize', FNT_SZ, 'Color', 'b');
plot(C(1), C(2), '.b', 'MarkerSize', 8);
text(D(1), D(2), 'D', 'FontSize', FNT_SZ, 'Color', 'b');
plot(D(1), D(2), '.b', 'MarkerSize', 8);
text(E(1), E(2), 'E', 'FontSize', FNT_SZ, 'Color', 'b');
plot(E(1), E(2), '.b', 'MarkerSize', 8);
text(F(1), F(2), 'F', 'FontSize', FNT_SZ, 'Color', 'b');
plot(F(1), F(2), '.b', 'MarkerSize', 8);

text(H_point(1), H_point(2), 'H', 'FontSize', FNT_SZ, 'Color', 'b');
plot(H_point(1), H_point(2), '.b', 'MarkerSize', 8);
text(G_point(1), G_point(2), 'G', 'FontSize', FNT_SZ, 'Color', 'b');
plot(G_point(1), G_point(2), '.b', 'MarkerSize', 8);
text(M_point(1), M_point(2), 'M', 'FontSize', FNT_SZ, 'Color', 'r');
plot(M_point(1), M_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');
text(R_point(1), R_point(2), 'R', 'FontSize', FNT_SZ, 'Color', 'b');
plot(R_point(1), R_point(2), '.b', 'MarkerSize', 8);
text(N_point(1), N_point(2), 'N', 'FontSize', FNT_SZ, 'Color', 'r');
plot(N_point(1), N_point(2), '.b', 'MarkerSize', 8, 'Color', 'r');

%%
% vanishing line - line, passing throught vanishing points
%   

lab = cross(A,B);
ldc = cross(D,C);
lad = cross(A,D);
lbc = cross(B,C);

v1 = cross(lab, ldc);
v1 = v1/v1(3);
v2 = cross(lad, lbc);
v2 = v2/v2(3);

vline = cross(v1, v2);
vline = vline/vline(3);

%%
% display the result
plot([A(1), v1(1)], [A(2), v1(2)], 'b');
plot([D(1), v1(1)], [D(2), v1(2)], 'b');
plot([B(1), v1(1)], [B(2), v1(2)], 'b');
plot([C(1), v1(1)], [C(2), v1(2)], 'b');

plot([A(1), v2(1)], [A(2), v2(2)], 'b');
plot([C(1), v2(1)], [C(2), v2(2)], 'b');
plot([B(1), v2(1)], [B(2), v2(2)], 'b');
plot([D(1), v2(1)], [D(2), v2(2)], 'b');

plot([v1(1), v2(1)], [v1(2), v2(2)], 'b--')
text(v1(1), v1(2), 'v1', 'FontSize', FNT_SZ, 'Color', 'b')
text(v2(1), v2(2), 'v2', 'FontSize', FNT_SZ, 'Color', 'b')

hold off

%%
H = [eye(2), zeros(2,1); vline(:)'];

fprintf("The vanishing line mapped to\n");
disp(inv(H)'*vline)

%%
tform = projective2d(H');
J = imwarp(im, tform, 'OutputView', imref2d(size(im)));
% J = imwarp(im, tform);

figure;
imshow (J);
hold on;

A_aff = H*A;
A_aff = A_aff/A_aff(3);

B_aff = H*B;
B_aff = B_aff/B_aff(3);

D_aff = H*D;
D_aff = D_aff/D_aff(3);

C_aff = H*C;
C_aff = C_aff/C_aff(3);

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

disp(['Angle between AB and DC after affine transform: ', num2str(theta_deg_ab_dc), ' degrees']);
disp(['Angle between AD and BC after affine transform: ', num2str(theta_deg_ad_bc), ' degrees']);

