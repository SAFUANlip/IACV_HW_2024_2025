function plot_corners(img, corners)
    % Plot the image
    figure; imshow(img); hold on;
    
    % Extract corner locations
    corner_points = corners.Location;
    
    % Plot each corner and add a number
    for i = 1:size(corner_points, 1)
        plot(corner_points(i, 1), corner_points(i, 2), 'ro', 'MarkerSize', 8); % Corner point
        text(corner_points(i, 1) + 5, corner_points(i, 2), sprintf('%d', i), 'Color', 'yellow', 'FontSize', 10); % Corner number
    end
    
    % Add a title
    title('Detected Corners with Numbers');
    hold off;
end
