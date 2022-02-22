function result_img = ButterworthEnhancement(input_img)
    final_img = ButterworthLowPassFilter(input_img, 30);
    % Sharpened image
    details = input_img - final_img;
    result_img = details + input_img;
