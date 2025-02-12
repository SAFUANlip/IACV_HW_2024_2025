%% Callibration Matrix K
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

% T matrix from previous part
Hr = [
    1.4888,   -0.7169,         0;
   -0.7169,    2.0515,         0;
   -0.0001,   -0.0011,    1.0000;
    ]

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

plot([A_point(1), v1_hor(1)], [A_point(2), v1_hor(2)], 'b');
plot([D_point(1), v1_hor(1)], [D_point(2), v1_hor(2)], 'b');
plot([B_point(1), v1_hor(1)], [B_point(2), v1_hor(2)], 'b');
plot([C_point(1), v1_hor(1)], [C_point(2), v1_hor(2)], 'b');

plot([A_point(1), v2_hor(1)], [A_point(2), v2_hor(2)], 'b');
plot([C_point(1), v2_hor(1)], [C_point(2), v2_hor(2)], 'b');
plot([B_point(1), v2_hor(1)], [B_point(2), v2_hor(2)], 'b');
plot([D_point(1), v2_hor(1)], [D_point(2), v2_hor(2)], 'b');


plot([v1_vert(1), v2_vert(1)], [v1_vert(2), v2_vert(2)], 'b--')
text(v1_vert(1), v1_vert(2), 'v1 Vertical', 'FontSize', FNT_SZ, 'Color', 'g')
text(v2_vert(1), v2_vert(2), 'v2 Vertical', 'FontSize', FNT_SZ, 'Color', 'g')

plot([v1_hor(1), v2_hor(1)], [v1_hor(2), v2_hor(2)], 'b--')
text(v1_hor(1), v1_hor(2), 'v1 Horizon', 'FontSize', FNT_SZ, 'Color', 'b')
text(v2_hor(1), v2_hor(2), 'v2 Horizon', 'FontSize', FNT_SZ, 'Color', 'b')

hold off

%% Find calibration matrix by equations, presented here
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8616767
% and contraints formuls from lecture slides
H = inv(Hr);
h1 = H(:,1); 
h2 = H(:,2); 
h3 = H(:,3); 

syms fx fy ux uy;
% definition from article
w = [1/(fx^2),   0, -ux/(fx^2);
           0,   1/(fy^2),     -uy/(fy^2);
     -ux/(fx^2), -uy/(fy^2), 1+(ux^2)/(fy^2)+(uy^2)/(fx^2)];

% required contraints 
eq1 = h1'*w*h2;
eq2 = h1'*w*h1 - h2'*w*h2;
eq3 = v2_vert'*w*h1;
eq4 = v2_vert'*w*h2;

eqns = [eq1 == 0, eq2 == 0, eq3 == 0, eq4 == 0];
S12 = solve(eqns, [fx, fy, ux, uy], 'Maxdegree', 4);

fx_result = double(S12.fx);
fy_result = double(S12.fy);
ux_result = double(S12.ux);
uy_result = double(S12.uy);

disp('All solutions for fx, fy, ux, uy:');
disp(table(fx_result, fy_result, ux_result, uy_result));

valid_idx = find(fx_result > 0 & fy_result > 0); % Adjust conditions as needed
if ~isempty(valid_idx)
    fx_result = fx_result(valid_idx(1));
    fy_result = fy_result(valid_idx(1));
    ux_result = ux_result(valid_idx(1));
    uy_result = uy_result(valid_idx(1));
else
    error('No valid solutions found.');
end

w_result = [1/(fx_result^2),   0, -ux_result/(fx_result^2);
           0,   1/(fy_result^2),     -uy_result/(fy_result^2);
     -ux_result/(fx_result^2), -uy_result/(fy_result^2), 1+(ux_result^2)/(fy_result^2)+(uy_result^2)/(fx_result^2)];

% Display the resulting w matrix
disp('w_result matrix:');
disp(w_result);

%%
K_result = [fx_result, 0, ux_result;
    0, fy_result, uy_result;
    0, 0, 1;
    ]

%%
% Assuming K and w_result are already computed

% Step 1: Calculate w_verification using K
w_verification = inv(K_result * K_result');

% Step 2: Display the computed w_verification
disp('Computed w from K:');
disp(w_verification);

% Step 3: Compare w_verification with w_result
disp('Original w_result:');
disp(w_result);

% Step 4: Verify if they are approximately equal
tolerance = 1e-1; % Set a numerical tolerance for comparison
if norm(w_verification - w_result, 'fro') < tolerance
    disp('Verification passed: w = inv(K * K^T) is satisfied.');
else
    disp('Verification failed: w does not match inv(K * K^T).');
end

diff = w_verification - w_result;
disp('Difference between w_verification and w_result:');
disp(diff);

%%
% Define w matrix in terms of K parameters

syms fx fy U0 V0 real

% Define K
K = [fx,  0,   U0;
     0,  fy,   V0;
     0,   0,    1];

% Compute K*K^T
KKT = K * K';

% Compute the determinant of K*K^T
det_KKT = det(KKT);

% Compute the adjugate of K*K^T
adj_KKT = adjoint(KKT);

% Compute inv(K*K^T)
inv_KKT = adj_KKT / det_KKT;

% Display results
disp('K*K^T:');
disp(KKT);

disp('Determinant of K*K^T:');
disp(det_KKT);

disp('Adjugate of K*K^T:');
disp(adj_KKT);

disp('Inverse of K*K^T:');
disp(inv_KKT);

% As result - formula in lecture for callibration matrix is wrong - use
% formula from article 


