function [img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img,tx,ty)
%%�������������ɲ�����ƽ��ͼ��
%%����Ϊtx,ty ,������x����������y����ע�������˳���෴
%%ʱ�䣺2017/6/30


[Hin,Win]=size(Img);  
img_translation  = zeros(Hin,Win);    %����������  
TranslationLutX = zeros(Hin,Win);
TranslationLutY = zeros(Hin,Win);  
  
  
for x=1:Win  
    for y=1:Hin  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        TranslationLutX(x,y) = x0;
        TranslationLutY(x,y) = y0;
        if x0>0 && y0>0&& Win >= x0&& Hin >= y0  
            img_translation(x,y) = Img(x0,y0);  
        end  
    end  
end  

end