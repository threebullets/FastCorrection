function [Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img,tx,ty)
% 函数功能：平移图像
% 函数输入：Img：待平移图像，uint8或double格式
%           tx：X方向平移像素点个数，向右平移为正，向左平移为负
%           ty：Y方向平移像素点个数，向下平移为正，向上平移为负
%函数输出：Img_translation：平移后图像,uint8格式
%          TranslationLutX：平移查找表X 
%          TranslationLutY：平移查找表Y 
%    时间：2017/11/16

%% init
[Hin,Win]=size(Img);  
Img_translation  = zeros(Hin,Win);    %像素是整数  
TranslationLutX = zeros(Hin,Win);
TranslationLutY = zeros(Hin,Win);  
  
%% Translation  
for x=1:Win  
    for y=1:Hin  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  

        if x0>0 && y0>0&& Win >= x0&& Hin >= y0  
            Img_translation(x,y) = Img(x0,y0); 
            TranslationLutX(x,y) = x0;
            TranslationLutY(x,y) = y0;
        end  
    end  
end  
%% output
Img_translation = uint8(Img_translation);
end