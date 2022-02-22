% --- Arnold Transform --- %
% Name: Liew Ying Jia
% Student ID: LS2015201

function return_img = ArnoldTransform(input_img)
    [row, col, channels] = size(input_img);

    cnt = 1;
    old_img = input_img;
    N = row; 
    current_img = zeros(size(input_img), 'uint8');

    while cnt<= 0.16*N
        for m = 1:row
            for n = 1:col
                x_new = mod((m+n), N) + 1;
                y_new = mod((m+2*n),N) + 1;
                current_img(m,n,:) = old_img(x_new, y_new,:);
            end
        end

        old_img = current_img;
        cnt = cnt + 1;
    end
    return_img = current_img;