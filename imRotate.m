function [Img_rotate,RotateLutX,RotateLutY] = imRotate(Img,angle)
% 函数功能：旋转图像
% 函数输入：Img：待旋转图像，uint8或double格式
%           angle：旋转方向为逆时针，例如angle=5,则逆时针旋转5度
% 函数输出：Img_rotate：旋转后图像,uint8格式
%          RotateLutX：旋转查找表X 
%          RotateLutY：旋转查找表Y 
%    时间：2017/11/16
%% init
[Hin,Win]=size(Img);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
Wout=round(abs(cos_val)*Win+Hin*abs(sin_val));  
Hout=round(abs(cos_val)*Hin+Win*abs(sin_val));  
Img_rotate  = zeros(Hout,Wout);    %像素是整数  
RotateLutX = zeros(Hout,Wout);
RotateLutY = zeros(Hout,Wout);  
  
 %% Rotate 
for x=1:Wout  
    for y=1:Hout  
        x0 = uint32(x*cos_val + y*sin_val -0.5*Wout*cos_val-0.5*Hout*sin_val+0.5*Win);  
        y0= uint32(y*cos_val-x*sin_val+0.5*Wout*sin_val-0.5*Hout*cos_val+0.5*Hin);      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        RotateLutX(x,y) = x0;
        RotateLutY(x,y) = y0;
        if x0>0 && y0>0&& Win >= x0&& Hin >= y0  
            Img_rotate(x,y) = Img(x0,y0);  
            RotateLutX(x,y) = x0;
            RotateLutY(x,y) = y0;
        end  
    end  
end  
%% output
Img_rotate = uint8(Img_rotate);
end