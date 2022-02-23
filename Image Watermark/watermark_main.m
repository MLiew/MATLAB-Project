function watermark_main(base_img_path, watermark_img_path,save_img1_path, save_img2_path)
    % base_img_path: the base image filepath 载体图像路径
    % watermark_img_path: the filepath of watermark image that has to be embedded on
    % the base image 水印图像路径
    % save_img1_path: the filepath to save the watermarked image
    % 保存加过水印的图像路径
    % save_img2_path: the filepath to save the extracted watermark image
    % 保存提取的水印图像路径
    
%% Embed watermark
% Read in the base image 读取载体图像
X = imread(base_img_path);
X = rgb2gray(X);
X = im2double(X);

figure
imshow(X)
title("Base Image 载体图像")

fun1 = @(block_struct) dct2(block_struct.data);
fun2 = @(block_struct) idct2(block_struct.data);

% 8x8 block performs DCT 8x8小块进行DCT变换
Y = blockproc(X,[8,8],fun1);

% create mask to retrieve middle freq matrix Bij
% 获取中频矩阵Bij
mid_mask = [0 0 0 1 1 1 0 0 
    0 1 1 1 1 0 0 0 
    0 1 1 1 0 0 0 0 
    1 1 1 0 0 0 0 0 
    1 1 0 0 0 0 0 0 
    1 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0];
fun3 = @(block_struct) mask_B(block_struct.data);
Y3 = blockproc(Y,[8 8], fun3); % 4x4 Bij matrix

% calculate Bij SVD  对Bij进行奇异值分解
Uij = zeros(256,256);
Sij = zeros(256,256);
Vij = zeros(256,256);

for m = 1:4:256
    for n = 1:4:256
        [U_temp,S_temp,V_temp] = svd(Y3(m:m+3,n:n+3));
        Uij(m:m+3,n:n+3) = U_temp;
        Sij(m:m+3,n:n+3) = S_temp;
        Vij(m:m+3,n:n+3) = V_temp;
    end
end

% get the max value of SVD and form matrix A, then SVD the matrix A
% 取最大奇异值构成矩阵A，再对其奇异值分解
A = blockproc(Y3,[4 4], @(block_struct) max(svd(block_struct.data)));  
[U,S,V] = svd(A);

% Read in watermark image 读取水印图像
watermark_img = imread(watermark_img_path);
watermark_img = rgb2gray(watermark_img);
watermark_img = imresize(watermark_img, [64 64]);
figure
imshow(watermark_img)
title("Watermark Image水印图像")

% Arnold Transform 猫脸变换
[arnold_img, ~] = ArnoldTransform(watermark_img);

% place the transformed watermark image on the matrix S 
% 将置乱后的水印图像叠加到矩阵S上
alpha = 0.15; % embedding factor 嵌入因子
D = S + alpha.*arnold_img;

% SVD on the new matrix S+alpha*W
% 对新矩阵S+alpha*W进行奇异值分解
[U1,S1,V1] = svd(D);

% inverse transform 经过反变换得到A'矩阵
A2 = U*S1*V'; % A'

% replace the corresponding element in the A' matrix with the largest singular value in Bij
% 将A'矩阵中的相应元素替换成Bij中最大的奇异值
x_idx = 1;
y_idx = 1;
for m = 1:4:256
    for n = 1:4:256
        Sij(m,n) = A2(x_idx,y_idx);
        y_idx = y_idx + 1;
    end
    y_idx = 1;
    x_idx = x_idx + 1;
end

% new Bij matrix 新的Bij矩阵
Bij_new = zeros(256,256);
for m = 1:4:256
    for n = 1:4:256
        Bij_new(m:m+3,n:n+3) = Uij(m:m+3,n:n+3)*Sij(m:m+3,n:n+3)*Vij(m:m+3,n:n+3)';
    end
end

% restore Bij back into the corresponding block 将Bij还原回相应的块中
fun4 = @(block_struct) expand_B(block_struct.data);
Y4 = blockproc(Bij_new,[4 4], fun4);

anti_mask = repmat(ones(8,8) - mid_mask,64);
Y_temp = Y.*anti_mask;
final_Y = Y_temp + Y4;

% DCT inverse transform DCT逆变换
I2 = blockproc(final_Y,[8 8],fun2);
figure
imshow(I2)
title("Watermarked Image 加过水印的图像")

% save the watermarked image 保存嵌入水印后的图像
imwrite(I2,save_img1_path)

%% Extract watermark
% read in watermarked image 读取水印图像
I = imread(save_img1_path);
I = im2double(I);

% divide image into 8x8 blocks for DCT 图像分成8*8小块，进行DCT变换
X = blockproc(I,[8,8],fun1); %dct

% get 16 mid freq coefficients in each block to form Bij*
% 取每块中16个中频系数构成Bij*
X1 = blockproc(X,[8 8], fun3);

% Bij* SVD Bij*奇异值分解
Uij_new = zeros(256,256);
Sij_new = zeros(256,256);
Vij_new = zeros(256,256);

for m = 1:4:256
    for n = 1:4:256
        [U_temp,S_temp,V_temp] = svd(X1(m:m+3,n:n+3));
        Uij_new(m:m+3,n:n+3) = U_temp;
        Sij_new(m:m+3,n:n+3) = S_temp;
        Vij_new(m:m+3,n:n+3) = V_temp;
    end
end

% take the largest singular value to form a matrix A* 取最大奇异值构成矩阵A*
A = blockproc(X1,[4 4], @(block_struct) max(svd(block_struct.data))); 

% A*=U*S*V*'
[~,S_A,~] = svd(A);

% D = U1*S*V1'
D = U1*S_A*V1';

% watermark matrix 水印矩阵 W*=(D-S)/alpha
W = (D-S)/alpha;

% Inverse Arnold Transform 猫脸逆变换
watermark = InverseArnoldTransform(W);
figure
imshow(watermark)
title("Extracted Watermark Image 提取的水印图像")

% Save the watermark image 保存提取的水印图像
imwrite(watermark,save_img2_path)
end

%% Inner functions
function Bij = mask_B(block_struct)
    mid_mask = [0 0 0 1 1 1 0 0 
        0 1 1 1 1 0 0 0 
        0 1 1 1 0 0 0 0 
        1 1 1 0 0 0 0 0 
        1 1 0 0 0 0 0 0 
        1 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0];
    test_A = mid_mask.*block_struct;
    idx_arr = zeros(4,4);
    idx_arr(1:3) = test_A(1,4:6); 
    idx_arr(4:7) = test_A(2,2:5);
    idx_arr(8:10) = test_A(3,2:4);
    idx_arr(11:13) = test_A(4,1:3);
    idx_arr(14:15) = test_A(5,1:2);
    idx_arr(16) = test_A(6,1);
    Bij = idx_arr;
end

% expand Bij into 8*8 matrix
function Bij_exp = expand_B(block_struct)
    Bij_new = block_struct;
    temp_mat = zeros(8,8);
    temp_mat(1,4:6) = Bij_new(1,1:3);
    temp_mat(2,2:5) = [Bij_new(1,4), Bij_new(2,1:3)];
    temp_mat(3,2:4) = [Bij_new(2,4), Bij_new(3,1:2)];
    temp_mat(4,1:3) = [Bij_new(3,3:4), Bij_new(4,1)];
    temp_mat(5,1:2) = Bij_new(4,2:3);
    temp_mat(6,1) = Bij_new(4,4);
    Bij_exp = temp_mat;
end
