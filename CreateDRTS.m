%%本脚本用于生成测试用畸变+旋转图像，先进行畸变操作，再进行旋转操作
%%畸变的参数是[-1，-2]，为枕形畸变，无黑边
%%旋转参数为旋转逆时针5度，即agree=5
%%平移参数-20，-20,向右向下20
%%缩放为原来两倍 
%%插值算法为最邻近插值法
%%时间：2017/5/26
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为畸变部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = [160, 0, 80; 0, 160, 80; 0, 0, 1 ];   %%内参
	D = [-0.4, -0.4];                               %%畸变参数
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    I_d = imread('D:\work\Projects\matlab\Correction\output\checkerboard.bmp');
    I_d_double = im2double(I_d);
    [M N] = size(I_d_double);
    I_r = zeros(M,N);

    %图像坐标系和矩阵的表示是相反的
    %[row,col] = find(X)，坐标按照列的顺序排列，这样好和reshape()匹配出响应的图像矩阵
    %[a1,a2]=find(a),找出a矩阵中非零元素所在行和列,并存在a1,a2中，（a1(i),a2(i)）即第i个非零元素的坐标
    %isnan(A)返回一个和A尺寸一样的数组，如果A中某个元素是NaN，则对应元素为1，否则为0
    [u v] = find(~isnan(I_r));                                  

    % XYZc 摄像机坐标系的值，但是已经归一化了，因为没有乘比例因子
    %公式 s[u v 1]' = A*[Xc Yc Zc]' ，其中s为比例因子，不加比例因子，Zc就为1，所以此时的Xc相对于( Xc/Zc )
    %inv(A)求A的逆矩阵
    XYZc= inv(A)*[u v ones(length(u),1)]'; 

    % 此时的x和y是没有畸变的
    x = XYZc(1,:);
    y = XYZc(2,:);
    r2 = x.^2+y.^2;
    % x和y进行畸变的
    xp = x.*(1+k1*r2 + k2*r2.^2);
    yp = y.*(1+k1*r2 + k2*r2.^2);

    % (u, v) 对应的畸变坐标 (u_d, v_d)
    ud = fx*xp + cx;
    vd = fy*yp + cy;
    u_d = reshape(ud,size(I_r));
    v_d = reshape(vd,size(I_r));

 %%最邻近插值
    u_d_int = floor(u_d);
    v_d_int = floor(v_d);
    img_distortion = zeros(M,N);    %%dataout为生成的畸变图像
for i = 1 : M
    for j = 1 : N
        if u_d_int(i,j)>0 && v_d_int(i,j)>0 && M >= u_d_int(i,j) && N >= v_d_int(i,j) 
            img_distortion(i,j) = I_d_double(u_d_int(i,j),v_d_int(i,j));
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%畸变后得到的畸变图像矩阵是img_distortion
%%以下为旋转部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = 5;
img1 = img_distortion;

[h,w]=size(img1);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
w2=round(abs(cos_val)*w+h*abs(sin_val));  
h2=round(abs(cos_val)*h+w*abs(sin_val));  
img_rotate  = zeros(h2,w2);    %像素是整数  
  
  
for x=1:w2  
    for y=1:h2  
        x0 = uint32(x*cos_val + y*sin_val -0.5*w2*cos_val-0.5*h2*sin_val+0.5*w);  
        y0= uint32(y*cos_val-x*sin_val+0.5*w2*sin_val-0.5*h2*cos_val+0.5*h);      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        if x0>0 && y0>0&& w >= x0&& h >= y0  
            img_rotate(x,y) = img1(x0,y0);  
        end  
    end  
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%旋转后得到的旋转图像矩阵是img_rotate
%%以下为平移部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%本脚本用于生成测试用平移图像
%%参数为tx,ty ,横轴是x方向，纵轴是y方向，注意和行列顺序相反
%%时间：2017/6/30

tx = -20;
ty = -20;
img1 = img_rotate;
[h0,w0]=size(img1);  
img_translation  = zeros(h0,w0);    %像素是整数  
  
  
for x=1:w0  
    for y=1:h0  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_translation(x,y) = img1(x0,y0);  
        end  
    end  
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%平移后得到的图像矩阵是img_translation
%%以下为缩放部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%本脚本用于生成测试用平移图像
%%参数为tx,ty ,横轴是x方向，纵轴是y方向，注意和行列顺序相反
%%时间：2017/6/30


img1 = img_translation;
[h0,w0]=size(img1);
h1 = 2*h0;
w1 = 2*w0;

fh = h0/h1;
fw = w0/w1;
img_scaler  = zeros(h1,w1);    %像素是整数  
  
  
for x=1:w1  
    for y=1:h1  
        x0 =x*fw;  
        y0= y*fh;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_scaler(x,y) = img1(x0,y0);  
        end  
    end  
end  




    %对比图像
    subplot(231);     
        imshow(I_d_double);
        title('原图像');
    subplot(232);
         imshow(img_distortion);
         title('畸变后');
    subplot(233);
         imshow(img_rotate);
         title('旋转后');
    subplot(234);
         imshow(img_translation);
         title('平移后');
    subplot(235);
        imshow(img_scaler);
        title('缩放后');
        
imwrite(img_scaler,'D:\work\Projects\matlab\Correction\output\create8.bmp');

