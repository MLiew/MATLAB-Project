% --- Square the image --- %

function final_img = SquareImg(input_img,maxSize)
    [row, col, channels] = size(input_img);
    if (row > maxSize)||(col > maxSize)
        final_img = imresize(input_img, [maxSize, maxSize]);
    elseif (row ~= col)
        tempSize = max(row, col);
        final_img = imresize(input_img, [tempSize, tempSize]);
    else
        final_img = input_img;
    end
    
    final_img = im2uint8(final_img);
end
