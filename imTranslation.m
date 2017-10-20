function [img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img,tx,ty)
%%本函数用于生成测试用平移图像
%%参数为tx,ty ,横轴是x方向，纵轴是y方向，注意和行列顺序相反
%%时间：2017/6/30


[Hin,Win]=size(Img);  
img_translation  = zeros(Hin,Win);    %像素是整数  
TranslationLutX = zeros(Hin,Win);
TranslationLutY = zeros(Hin,Win);  
  
  
for x=1:Win  
    for y=1:Hin  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %最邻近插值  
        y0=round(y0);         %最邻近插值  
        TranslationLutX(x,y) = x0;
        TranslationLutY(x,y) = y0;
        if x0>0 && y0>0&& Win >= x0&& Hin >= y0  
            img_translation(x,y) = Img(x0,y0);  
        end  
    end  
end  

end