function [Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img,fh,fw,varargin)
% 函数功能：缩放图像
% 函数输入：Img：待缩放图像，uint8或double格式
%           fh：高方向缩放系数
%           fw：宽方向缩放系数
%           Notes:缩放系数为放大倍数的倒数。例如10*10图像缩放为20*20,则fh = 0.5;fw = 0.5
%           if 需要限定输出图像大小（must>=缩放图像大小），则输出图像靠左上角显示，其余部分为黑边。
%           varargin{1}：高方向输出图像大小
%           varargin{2}：宽方向输出图像大小
%函数输出：Img_scaler：缩放后图像,uint8格式
%          ScalerLutX：缩放查找表X 
%          ScalerLutY：缩放查找表Y 
%    时间：2017/11/16
%% init
Img = double(Img);
[inputH,inputW]=size(Img);
output_H = round(inputH/fh);    
output_W = round(inputW/fw);
if nargin == 3
        output_H = output_H;
        output_W = output_W;
elseif nargin == 5
            output_H = varargin{1};
            output_W = varargin{2};
else
        disp('The number of imScaler''s input parameters of  is WRONG! ');
        return;
end
Img_scaler  = zeros(output_H,output_W);   
ScalerLutX = zeros(output_H,output_W);
ScalerLutY = zeros(output_H,output_W);  
%% Scaler  
for i=1:output_H  
    for j=1:output_W  
        i1 =i*fw;  
        j1= j*fh;      
        %最邻近插值法   
        i1=round(i1);          
        j1=round(j1);      
        
        if i1>0 && j1>0&& inputH >= i1&& inputW >= j1  
            ScalerLutX(i,j) = i1;
            ScalerLutY(i,j) = j1;
            Img_scaler(i,j) = Img(i1,j1);  
        end  
    end  
end  
%% output
Img_scaler = uint8(Img_scaler);
end