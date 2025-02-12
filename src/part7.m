%% 3D views
close all
clearvars
clc

%%

HEIGHT_REAL = 0.36288;
LENGTH_REAL= 1/3;
DEPTH_REAL = 0.33957;

E_real = [0 0 0];
F_real = [LENGTH_REAL 0 0];
G_real = [LENGTH_REAL*2 0 0];
K_real = [LENGTH_REAL*3 0 0];

A_real = [0 HEIGHT_REAL 0];
D_real = [LENGTH_REAL HEIGHT_REAL 0];
H_real = [LENGTH_REAL*2 HEIGHT_REAL 0];
L_real = [LENGTH_REAL*3 HEIGHT_REAL 0];

B_real = [0 HEIGHT_REAL -DEPTH_REAL];
C_real = [LENGTH_REAL HEIGHT_REAL -DEPTH_REAL];

camera_real = [0.2046, -0.1268, 0.5472];

%%
% Ellipse parameters
center = [0.4548, 0.1814, -0.0673]; % Ellipse center
height = 0.0482; % Minor axis (shorter)
length = 0.0658; % Major axis (longer)
rotation_angle = -2.6416; % Rotation angle in radians

%% Generate ellipse points in the XZ-plane
theta = linspace(0, 2*pi, 100); % Parametric angle
ellipse_x = (length / 2) * cos(theta); % Major axis
ellipse_z = (height / 2) * sin(theta); % Minor axis
ellipse_y = zeros(size(theta)); % Zero height ensures ellipse lies in XZ

% Create rotation matrix for alignment within the XZ plane
R_align = [cos(rotation_angle), 0, sin(rotation_angle);
           0,                 1, 0;
          -sin(rotation_angle), 0, cos(rotation_angle)]; % Rotate within the XZ plane

% Rotate and translate the ellipse points
ellipse_rotated = R_align * [ellipse_x; ellipse_y; ellipse_z]; % Apply rotation
ellipse_3D = bsxfun(@plus, ellipse_rotated, center'); % Translate to the center


%%
% Create figure
figure;
hold on;
grid on;
axis equal;

% Plot the ellipse
plot3(ellipse_3D(1, :), ellipse_3D(2, :), ellipse_3D(3, :), 'm-', 'LineWidth', 2);
scatter3(center(1), center(2), center(3), 50, 'm', 'filled'); % Mark center
text(center(1), center(2), center(3), ' Ellipse Center', 'Color', 'm', 'FontSize', 10);


% Plot the axes from point E
quiver3(E_real(1), E_real(2), E_real(3), 1, 0, 0, 'r', 'LineWidth', 2); % X-axis
quiver3(E_real(1), E_real(2), E_real(3), 0, 1, 0, 'g', 'LineWidth', 2); % Y-axis
quiver3(E_real(1), E_real(2), E_real(3), 0, 0, 1, 'b', 'LineWidth', 2); % Z-axis

% Plot the points
points = [E_real; F_real; G_real; K_real; ...
          A_real; D_real; H_real; L_real; ...
          B_real; C_real];
point_labels = {'E', 'F', 'G', 'K', ...
                'A', 'D', 'H', 'L', ...
                'B', 'C'};

% Plot each point with labels
for i = 1:size(points, 1)
    plot3(points(i, 1), points(i, 2), points(i, 3), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
    text(points(i, 1), points(i, 2), points(i, 3), [' ' point_labels{i}], 'FontSize', 10, 'Color', 'k');
end

% Highlight the camera position
plot3(camera_real(1), camera_real(2), camera_real(3), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
text(camera_real(1), camera_real(2), camera_real(3), ' Camera', 'FontSize', 10, 'Color', 'r');

% Base rectangle (Ground plane)
plot3([E_real(1), F_real(1)], [E_real(2), F_real(2)], [E_real(3), F_real(3)], 'b-', 'LineWidth', 1.5);
plot3([F_real(1), G_real(1)], [F_real(2), G_real(2)], [F_real(3), G_real(3)], 'b-', 'LineWidth', 1.5);
plot3([G_real(1), K_real(1)], [G_real(2), K_real(2)], [G_real(3), K_real(3)], 'b-', 'LineWidth', 1.5);
plot3([K_real(1), E_real(1)], [K_real(2), E_real(2)], [K_real(3), E_real(3)], 'b-', 'LineWidth', 1.5);

% Top rectangle (Height plane)
plot3([A_real(1), D_real(1)], [A_real(2), D_real(2)], [A_real(3), D_real(3)], 'b-', 'LineWidth', 1.5);
plot3([D_real(1), H_real(1)], [D_real(2), H_real(2)], [D_real(3), H_real(3)], 'b-', 'LineWidth', 1.5);
plot3([H_real(1), L_real(1)], [H_real(2), L_real(2)], [H_real(3), L_real(3)], 'b-', 'LineWidth', 1.5);
plot3([L_real(1), A_real(1)], [L_real(2), A_real(2)], [L_real(3), A_real(3)], 'b-', 'LineWidth', 1.5);

% Vertical connections
plot3([E_real(1), A_real(1)], [E_real(2), A_real(2)], [E_real(3), A_real(3)], 'k-', 'LineWidth', 1.5);
plot3([F_real(1), D_real(1)], [F_real(2), D_real(2)], [F_real(3), D_real(3)], 'k-', 'LineWidth', 1.5);
plot3([G_real(1), H_real(1)], [G_real(2), H_real(2)], [G_real(3), H_real(3)], 'k-', 'LineWidth', 1.5);
plot3([K_real(1), L_real(1)], [K_real(2), L_real(2)], [K_real(3), L_real(3)], 'k-', 'LineWidth', 1.5);

% Top roof (Optional)
plot3([A_real(1), B_real(1)], [A_real(2), B_real(2)], [A_real(3), B_real(3)], 'g-', 'LineWidth', 1.5);
plot3([B_real(1), C_real(1)], [B_real(2), C_real(2)], [B_real(3), C_real(3)], 'g-', 'LineWidth', 1.5);
plot3([C_real(1), D_real(1)], [C_real(2), D_real(2)], [C_real(3), D_real(3)], 'g-', 'LineWidth', 1.5);

% Set axis properties
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('Corrected 3D Scene with Defined Points');
view(3);