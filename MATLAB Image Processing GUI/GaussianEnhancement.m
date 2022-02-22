function result_img = GaussianEnhancement(input_img)
    final_img = GaussianLowPassFilter(input_img, 30);
    % Sharpened image
    details = input_img - final_img;
    result_img = details + input_img;
