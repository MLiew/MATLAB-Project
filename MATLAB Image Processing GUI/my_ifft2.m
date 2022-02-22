% --- Inverse Discrete Fourier Transform --- %
% Name: Liew Ying Jia
% Student ID: LS2015201

function [ F ] = my_ifft2( f )
% This is my Inverse Discrete Fourier Transform function
% Convert the input that was in frequency domain back to spatial domain

[M, N, ~] = size(f);% Get the number of rows and columns in f
wM        = zeros(M, M);% Asign zeros matrix
wN        = zeros(N, N);% Asign zeros matrix

% As the 2D IDFT is separable, calculate the exponential part of IDFT separately
% as wM and wN
%------------------------------------------------------------------------%
% Calculate wM
% Two for loops: increasing the x-value before increasing u-value and form
% two for loops
for u = 0 : (M - 1)
    for x = 0 : (M - 1)
        wM(u+1, x+1) = exp(2 * pi * 1i / M * x * u); % wM is the calculation of exp((2j*pi*u*x)/M)
    end    
end

% Calculate wN
% Two for loops: increasing the y-value before increasing v-value and form
% two for loops
for v = 0 : (N - 1)
    for y = 0 : (N - 1)
        wN(y+1, v+1) = exp(2 * pi * 1i / N * y * v); % wN is the calculation of exp((2j*pi*v*y)/N)
    end    
end

% The formula for IDFT
F = 1/(M*N)*wM * im2double(f) * wN; % Output = 1/(M*N)*wM*input*wN  [Matrix Multiplication]
end


