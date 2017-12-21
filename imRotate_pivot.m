function [Img_rotate,RotateLutX,RotateLutY] = imRotate_pivot(Img,angle,pivotH,pivotW)
% �������ܣ���תͼ��
% �������룺Img������תͼ��uint8��double��ʽ
%           angle����ת����Ϊ��ʱ�룬����angle=5,����ʱ����ת5��
%           pivotH���߷����ϵ���ת���ĵ�
%           pivotW�������ϵ���ת���ĵ�
% ���������Img_rotate����ת��ͼ��,uint8��ʽ
%          RotateLutX����ת���ұ�X 
%          RotateLutY����ת���ұ�Y 
%    ʱ�䣺2017/11/16
%% init
[Hin,Win]=size(Img);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
Wout=Win;  
Hout=Hin;  
Img_rotate  = zeros(Hout,Wout);    %����������  
RotateLutX = zeros(Hout,Wout);
RotateLutY = zeros(Hout,Wout);  
  
%% Rotate
for x=1:Hout  
    for y=1:Wout  
        x0 = uint32(x*cos_val + y*sin_val -pivotW*cos_val-pivotH*sin_val+pivotW);  
        y0= uint32(y*cos_val-x*sin_val+pivotW*sin_val-pivotH*cos_val+pivotH);      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  

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