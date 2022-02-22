% --- Butterworth High Pass Filter --- %
% Name: Liew Ying Jia
% Student ID: LS2015201

function final_img = ButterworthHighPassFilter(input_img, d0)
[row, col, channels] = size(input_img);

%-------------------Define Filters-----------------%
nn = 2; 

final_img = zeros(size(input_img),'uint8');
for k = 1:1:channels
    f = double(input_img(:,:,k)); 
    g = my_fft2(f); % 2D Fast Fourier Transform  
    g = fftshift(g);

    [M,N] = size(g); 
    m = floor(M/2); 
    n = floor(N/2); % Round the number to the smaller integer 

    result = zeros([M,N]);

    %Low Pass Filter
    for i = 1:M  
           for j = 1:N  
               d = sqrt((i-m)^2+(j-n)^2);  % Distance
               h = 1/(1+(d0/d)^(2*nn));  % calculate Butterworth High Pass Filter transform function  
               result(i,j) = h * g(i,j);  
           end  
    end  
   
    result = ifftshift(result); % Shifting the zero-frequency back to its original position 
    J2 = my_ifft2(result); % Inverse Fourier Transform
    J3 = uint8(real(J2));  % Cast the data format into uint8
    final_img(:,:,k) = J3;
end