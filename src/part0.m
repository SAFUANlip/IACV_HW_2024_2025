%% Extracting main features, lines, corners

close all
clearvars
clc

%%
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/');
addpath('/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/feature_extracture_functions/');

%%
% load an image of a plane
img = imread("/Users/safuan/Documents/MATLAB/ImageAnalysis/HW/images/Look-outCat.jpg");
img = rgb2gray(img);

%%
lines = get_lines(img);

fig = plot_lines(img, lines, "red", "lines")

figure(1), imshow(fig)

%%
corners = get_corners(img);
plot_corners(img, corners)
