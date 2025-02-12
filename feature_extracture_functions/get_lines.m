function lines = get_lines(img)
% Hough Transform
% source code: https://it.mathworks.com/help/images/hough-transform.html

% edge detection by Canny algorithm
BW = edge(img, 'canny', [0.03, 0.05]);

figure;
imshow(BW);

% Hough Transform 
[H, theta, rho] = hough(BW, 'Theta', -90:0.5:89.5, 'RhoResolution', 0.5);

% Find the peaks in the Hough transform matrix
P = houghpeaks(H, 100, 'threshold', ceil(0.1 * max(H(:))), 'NHoodSize', [15, 15]);

% Find lines in the image 
lines = houghlines(BW,theta, rho, P, 'FillGap', 30, 'MinLength', 40);

end