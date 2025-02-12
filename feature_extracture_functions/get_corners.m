function corners = get_corners(img)
    % get img corners using Harris Features
    % Ensure the image is grayscale
    % source: https://it.mathworks.com/help/vision/ref/detectharrisfeatures.html

    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Detect Harris corners

    corners = detectHarrisFeatures(img, 'MinQuality', 0.0005);
end