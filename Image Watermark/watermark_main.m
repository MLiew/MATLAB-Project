function watermark_main(base_img_path, watermark_img_path,save_img1_path, save_img2_path)
    % base_img_path: the base image filepath ����ͼ��·��
    % watermark_img_path: the filepath of watermark image that has to be embedded on
    % the base image ˮӡͼ��·��
    % save_img1_path: the filepath to save the watermarked image
    % ����ӹ�ˮӡ��ͼ��·��
    % save_img2_path: the filepath to save the extracted watermark image
    % ������ȡ��ˮӡͼ��·��
    
%% Embed watermark
% Read in the base image ��ȡ����ͼ��
X = imread(base_img_path);
X = rgb2gray(X);
X = im2double(X);

figure
imshow(X)
title("Base Image ����ͼ��")

fun1 = @(block_struct) dct2(block_struct.data);
fun2 = @(block_struct) idct2(block_struct.data);

% 8x8 block performs DCT 8x8С�����DCT�任
Y = blockproc(X,[8,8],fun1);

% create mask to retrieve middle freq matrix Bij
% ��ȡ��Ƶ����Bij
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

% calculate Bij SVD  ��Bij��������ֵ�ֽ�
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
% ȡ�������ֵ���ɾ���A���ٶ�������ֵ�ֽ�
A = blockproc(Y3,[4 4], @(block_struct) max(svd(block_struct.data)));  
[U,S,V] = svd(A);

% Read in watermark image ��ȡˮӡͼ��
watermark_img = imread(watermark_img_path);
watermark_img = rgb2gray(watermark_img);
watermark_img = imresize(watermark_img, [64 64]);
figure
imshow(watermark_img)
title("Watermark Imageˮӡͼ��")

% Arnold Transform è���任
[arnold_img, ~] = ArnoldTransform(watermark_img);

% place the transformed watermark image on the matrix S 
% �����Һ��ˮӡͼ����ӵ�����S��
alpha = 0.15; % embedding factor Ƕ������
D = S + alpha.*arnold_img;

% SVD on the new matrix S+alpha*W
% ���¾���S+alpha*W��������ֵ�ֽ�
[U1,S1,V1] = svd(D);

% inverse transform �������任�õ�A'����
A2 = U*S1*V'; % A'

% replace the corresponding element in the A' matrix with the largest singular value in Bij
% ��A'�����е���ӦԪ���滻��Bij����������ֵ
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

% new Bij matrix �µ�Bij����
Bij_new = zeros(256,256);
for m = 1:4:256
    for n = 1:4:256
        Bij_new(m:m+3,n:n+3) = Uij(m:m+3,n:n+3)*Sij(m:m+3,n:n+3)*Vij(m:m+3,n:n+3)';
    end
end

% restore Bij back into the corresponding block ��Bij��ԭ����Ӧ�Ŀ���
fun4 = @(block_struct) expand_B(block_struct.data);
Y4 = blockproc(Bij_new,[4 4], fun4);

anti_mask = repmat(ones(8,8) - mid_mask,64);
Y_temp = Y.*anti_mask;
final_Y = Y_temp + Y4;

% DCT inverse transform DCT��任
I2 = blockproc(final_Y,[8 8],fun2);
figure
imshow(I2)
title("Watermarked Image �ӹ�ˮӡ��ͼ��")

% save the watermarked image ����Ƕ��ˮӡ���ͼ��
imwrite(I2,save_img1_path)

%% Extract watermark
% read in watermarked image ��ȡˮӡͼ��
I = imread(save_img1_path);
I = im2double(I);

% divide image into 8x8 blocks for DCT ͼ��ֳ�8*8С�飬����DCT�任
X = blockproc(I,[8,8],fun1); %dct

% get 16 mid freq coefficients in each block to form Bij*
% ȡÿ����16����Ƶϵ������Bij*
X1 = blockproc(X,[8 8], fun3);

% Bij* SVD Bij*����ֵ�ֽ�
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

% take the largest singular value to form a matrix A* ȡ�������ֵ���ɾ���A*
A = blockproc(X1,[4 4], @(block_struct) max(svd(block_struct.data))); 

% A*=U*S*V*'
[~,S_A,~] = svd(A);

% D = U1*S*V1'
D = U1*S_A*V1';

% watermark matrix ˮӡ���� W*=(D-S)/alpha
W = (D-S)/alpha;

% Inverse Arnold Transform è����任
watermark = InverseArnoldTransform(W);
figure
imshow(watermark)
title("Extracted Watermark Image ��ȡ��ˮӡͼ��")

% Save the watermark image ������ȡ��ˮӡͼ��
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
