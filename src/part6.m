%% Localisation
close all
clearvars
clc

%%
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/');
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/ellipse_functions/');


%% load an image of a plane
im = imread("/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/images/Look-outCat.jpg");
%im = imresize(im);

A_point = [402.1181 249.3789];
B_point = [463.7551 455.0959];
C_point = [719.1842 470.9011];
D_point = [775.7712 297.2566];
E_point = [331.6935 691.2217];
F_point = [802.1764 689.3995];


K = [
    708.4832,         0,  813.9804;
         0,  766.1626,  563.7740;
         0,         0,    1.0000;
    ];

H_vert = [
    -0.999883942983777, -0.015230651846324, -3.575018207693751e-04;
    0.026556379446092, -1.743434371814285, 9.637491760607269e-04;
    -3.658786395209837e-04, 5.472144926706133e-04, 1;
    ]

%%
% applying the homography to the image
tform = projective2d(H_vert');
img_hom = imwarp(im, tform);

img_hom = flip(img_hom, 1); % vertical flip
img_hom = flip(img_hom, 2); % horizontal + vertical flip

%%
[A_point(1), A_point(2)] = transformPointsForward(tform, A_point(1), A_point(2));
[D_point(1), D_point(2)] = transformPointsForward(tform, D_point(1), D_point(2));
[E_point(1), E_point(2)] = transformPointsForward(tform, E_point(1), E_point(2));
[F_point(1), F_point(2)] = transformPointsForward(tform, F_point(1), F_point(2));

%%

HEIGHT_REAL = 0.36288;
LENGTH_REAL= 1/3;
DEPTH_REAL = 0.33957;

% real points in the world 
real_points = [0          0;            % E
               0          HEIGHT_REAL;    % A
               LENGTH_REAL HEIGHT_REAL;    % D
               LENGTH_REAL 0;];          % F

%%
image_points = [E_point; A_point; D_point; F_point];

% homography from image to world 
tform = fitgeotrans(image_points, real_points, 'projective');
H_img_to_world  = (tform.T).';

% homograpgy from world to image
H_world_to_img = inv(H_img_to_world * H_vert);


% localization procedure splitting homography columns
h1 = H_world_to_img(:,1);
h2 = H_world_to_img(:,2);
h3 = H_world_to_img(:,3);

%%
% https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr98-71.pdf
% arbitrary scalar.
lambda = 1 / norm(K \ h1);

% r1 = K^-1 * h1 normalized
r1 = (K \ h1) * lambda;
r2 = (K \ h2) * lambda;
r3 = cross(r1,r2);

% rotation matrix
R = [r1, r2, r3];

%%
% SVD to reduce noize effect
[U, ~, V] = svd(R);
R = U * V';

% Translation vector
T = (K \ (lambda * h3));

cameraRotation = R.';

%%
cameraPosition = -R.' * T
