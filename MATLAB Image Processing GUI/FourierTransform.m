% --- Fourier Transform --- %

%  Return Fourier Transform Frequency Domain
function return_img = FourierTransform(input_img)
    channels = size(input_img,3);
    f = double(input_img(:,:,1));
    g = my_fft2(f); % 2D Fast Fourier Transform  
    g = fftshift(g);  % Shifting the zero-frequency back to the center       
    return_img = log(1+abs(g));
    return_img = uint8(mat2gray(return_img) * 255);
