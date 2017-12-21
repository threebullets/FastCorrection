function [Img_rotate,RotateLutX,RotateLutY] = imRotate_pivot(Img,angle,pivotH,pivotW)
% 函数功能：旋转图像
% 函数输入：Img：待旋转图像，uint8或double格式
%           angle：旋转方向为逆时针，例如angle=5,则逆时针旋转5度
%           pivotH：高方向上的旋转中心点
%           pivotW：宽方向上的旋转中心点
% 函数输出：Img_rotate：旋转后图像,uint8格式
%          RotateLutX：旋转查找表X 
%          RotateLutY：旋转查找表Y 
%    时间：2017/11/16
%% init
[Hin,Win]=size(Img);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
Wout=Win;  
Hout=Hin;  
Img_rotate  = zeros(Hout,Wout);    %像素是整数  
RotateLutX = zeros(Hout,Wout);
RotateLutY = zeros(Hout,Wout);  
  
%% Rotate
for x=1:Hout  
    for y=1:Wout  
        x0 = uint32(x*cos_val + y*sin_val -pivotW*cos_val-pivotH*sin_val+pivotW);  
        y0= uint32(y*cos_val-x*sin_val+pivotW*sin_val-pivotH*cos_val+pivotH);      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  

        if x0>0 && y0>0&& Hin >= x0&& Win >= y0  
            Img_rotate(x,y) = Img(x0,y0);  
            RotateLutX(x,y) = x0;
            RotateLutY(x,y) = y0;
        end  
    end  
end  
%% output
Img_rotate = uint8(Img_rotate);
end