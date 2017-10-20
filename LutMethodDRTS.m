%%本脚本用于用逆方法，将测试用一步校正畸变+旋转+平移+缩放
%%先进行旋转操作，再进行畸变操作
%%旋转参数为旋转逆时针-5度，即agree=-5
%%畸变的参数是[1，2]，为桶形畸变，会产生黑边
%%平移参数为向左20向上20 (左正右负)
%%缩放参数为缩小为原图的一半
%%插值算法为最邻近插值法
%%时间：2017/5/26
clear;
clc;
tic
img1 = imread('D:\work\Projects\matlab\Correction\output\create8.bmp');
[sh,sw]=size(img1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为缩放部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h0,w0]=size(img1);
h1 = 0.5*h0;     %缩小两倍
w1 = 0.5*h0;
fh = h0/h1;
fw = w0/w1;
img_scaler  = zeros(h1,w1);    %像素是整数  
ScalerLutX = zeros(h1,w1);
ScalerLutY = zeros(h1,w1);  
  
for x=1:w1  
    for y=1:h1  
        x0 =x*fw;  
        y0= y*fh;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        ScalerLutX(x,y) = x0;
        ScalerLutY(x,y) = y0;
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_scaler(x,y) = img1(x0,y0);  
        end  
    end  
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为平移部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx = 20;
ty = 20;

[h0,w0]=size(img_scaler);  
img_translation  = zeros(h0,w0);    %像素是整数  
TranslationLutX = zeros(h0,w0);
TranslationLutY = zeros(h0,w0);  
  
  
for x=1:w0  
    for y=1:h0  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        TranslationLutX(x,y) = x0;
        TranslationLutY(x,y) = y0;
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_translation(x,y) = img_scaler(x0,y0);  
        end  
    end  
end  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为旋转部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = -5;


[h,w]=size(img_translation);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
w2=round(abs(cos_val)*w+h*abs(sin_val));  
h2=round(abs(cos_val)*h+w*abs(sin_val));  
img_rotate  = zeros(h2,w2);    %像素是整数  
RotateLutX = zeros(h2,w2);
RotateLutY = zeros(h2,w2);  
  
  
for x=1:w2  
    for y=1:h2  
        x0 = uint32(x*cos_val + y*sin_val -0.5*w2*cos_val-0.5*h2*sin_val+0.5*w);  
        y0= uint32(y*cos_val-x*sin_val+0.5*w2*sin_val-0.5*h2*cos_val+0.5*h);      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        RotateLutX(x,y) = x0;
        RotateLutY(x,y) = y0;
        if x0>0 && y0>0&& w >= x0&& h >= y0  
            img_rotate(x,y) = img_translation(x0,y0);  
        end  
    end  
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%旋转后得到的旋转图像矩阵是img_rotate
%%以下为畸变部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = [160, 0, 80; 0, 160, 80; 0, 0, 1 ];   %%内参
	D = [0.4, 0.4];                               %%畸变参数
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    [M,N] = size(img_rotate);
    I_r = zeros(M,N);

    %图像坐标系和矩阵的表示是相反的
    %[row,col] = find(X)，坐标按照列的顺序排列，这样好和reshape()匹配出响应的图像矩阵
    %[a1,a2]=find(a),找出a矩阵中非零元素所在行和列,并存在a1,a2中，（a1(i),a2(i)）即第i个非零元素的坐标
    %isnan(A)返回一个和A尺寸一样的数组，如果A中某个元素是NaN，则对应元素为1，否则为0
    [u,v] = find(~isnan(I_r));                                  
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
    DistortionLutX = floor(u_d);
    DistortionLutY = floor(v_d);

    
img_Distortion = zeros(M,N);    
for i = 1 : M
    for j = 1 : N
        if DistortionLutX(i,j)>0 && DistortionLutY(i,j)>0 && M >= DistortionLutX(i,j) && N >= DistortionLutY(i,j) 
            img_Distortion(i,j) = img_rotate(DistortionLutX(i,j),DistortionLutY(i,j));    
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为统一校正
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M,N] = size(img_Distortion);



[P,Q] = size(RotateLutX);
temp1X = zeros(P,Q);
temp1Y = zeros(P,Q);
for i = 1 : P
    for j = 1 : Q
        if DistortionLutX(i,j)>0 && DistortionLutY(i,j)>0 && P >= DistortionLutX(i,j) && Q >= DistortionLutY(i,j)  
            temp1X(i,j) = RotateLutX(DistortionLutX(i,j),DistortionLutY(i,j));
            temp1Y(i,j) = RotateLutY(DistortionLutX(i,j),DistortionLutY(i,j));
        end
    end
end






[P,Q] = size(TranslationLutX);
temp2X = zeros(P,Q);
temp2Y = zeros(P,Q);
for i = 1 : P
    for j = 1 : Q
        if temp1X(i,j)>0 && temp1Y(i,j)>0 && P >= temp1X(i,j) && Q >= temp1Y(i,j)  
            temp2X(i,j) = TranslationLutX(temp1X(i,j),temp1Y(i,j));
            temp2Y(i,j) = TranslationLutY(temp1X(i,j),temp1Y(i,j));
        end
    end
end

[P,Q] = size(ScalerLutX);
UnifyLutX = zeros(P,Q);
UnifyLutY = zeros(P,Q);
for i = 1 : P
    for j = 1 : Q
        if temp2X(i,j)>0 && temp2Y(i,j)>0 && P >= temp2X(i,j) && Q >= temp2Y(i,j)  
            UnifyLutX(i,j) = ScalerLutX(temp2X(i,j),temp2Y(i,j));
            UnifyLutY(i,j) = ScalerLutY(temp2X(i,j),temp2Y(i,j));      
        end
    end
end
% for i = 1 : M
%     for j = 1 : N
%         if DistortionLutX(i,j)>0 && DistortionLutY(i,j)>0 && M >= DistortionLutX(i,j) && N >= DistortionLutY(i,j)  
%             temp1X(i,j) = RotateLutX(DistortionLutX(i,j),DistortionLutY(i,j))));
%             temp1Y(i,j) = RotateLutY(DistortionLutX(i,j),DistortionLutY(i,j))));
%             temp2X(i,j) = TranslationLutX(temp1X(i,j),temp1Y(i,j))));
%             temp2Y(i,j) = TranslationLutY(temp1X(i,j),temp1Y(i,j))));
%             UnifyLutx(i,j) = ScalerLutX(temp2X(i,j),temp2Y(i,j))));
%             UnifyLuty(i,j) = ScalerLutY(temp2X(i,j),temp2Y(i,j))));      
% %             UnifyLutx(i,j) = ScalerLutX(TranslationLutX(RotateLutX(DistortionLutX(i,j),DistortionLutY(i,j))));
% %             UnifyLuty(i,j) = ScalerLutY(TranslationLutY(RotateLutY(DistortionLutX(i,j),DistortionLutY(i,j))));
%         end
%     end
% end
 
 
 
dataout = zeros(P,Q);
 for i = 1 : P
     for j = 1 : Q
         if UnifyLutX(i,j)>0 && UnifyLutY(i,j)>0 && sh >= UnifyLutX(i,j) && sw >= UnifyLutY(i,j) 
             dataout(i,j) = img1(UnifyLutX(i,j),UnifyLutY(i,j));
         end
     end
 end


    %对比图像
    subplot(231);     
        imshow(img1);
        title('原图像');
    subplot(232);
         imshow(img_scaler);
         title('校正缩放');
    subplot(233);
         imshow(img_translation);
         title('校正平移');
    subplot(234);
         imshow(img_rotate);
         title('校正旋转');
    subplot(235);
        imshow(img_Distortion);
        title('校正畸变');
    subplot(236);
        imshow(dataout);
        title('统一校正');     
        
        
imwrite(dataout,'D:\work\Projects\matlab\Correction\output\LutMethod.bmp');

[P,Q] = size(UnifyLutX);
loc = zeros(P,Q);
for i = 1 : P
    for j = 1 :Q
        if UnifyLutX(i,j)==0 || UnifyLutY(i,j)==0
            loc(i,j) = 0;
        else
            loc(i,j) = (UnifyLutX(i,j) - 1) * 346 + (UnifyLutY(i,j) - 1);
        end
    end
end
coe(loc,'LutMethodloc');
disp('已生成LutMethodloc.coe文件')
toc

