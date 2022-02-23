function [arnold_img,recover_img] = ArnoldTransform(data)
% è���任 Arnold Transform

    [m,n,r]=size(data);
    if r>1
        data1=rgb2gray(data);
    else
        data1=data;
    end

    data1 = imresize(data1,[64 64]); % resize the image to 64*64
    [m,n]=size(data1);
    
    data1=im2double(data1);
    
    % parameters for arnold transform
    n1=10; 
    a=3;
    b=5;
    N=m; 
    
    % Arnold transform
    imgn=zeros(m,n);
    for i=1:n1
        for y=1:m
            for x=1:n
    xx=mod((x-1)+b*(y-1),N)+1;  % mod��a,b��
    yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;
    imgn(yy,xx)=data1(y,x);
            end
        end
    data1=imgn;
    end
    
    arnold_img = imgn;
    
    % ��ԭ Recover
    img=imgn;
    for i=1:n1
        for y=1:m
            for x=1:n
                 xx=mod((a*b+1)*(x-1)-b*(y-1),N)+1;
                 yy=mod(-a*(x-1)+(y-1),N)+1;
                 imgn(yy,xx)=data1(y,x);
            end
        end
    data1=imgn;
    end
    
    recover_img = imgn;
end