function [Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img,tx,ty)
% �������ܣ�ƽ��ͼ��
% �������룺Img����ƽ��ͼ��uint8��double��ʽ
%           tx��X����ƽ�����ص����������ƽ��Ϊ��������ƽ��Ϊ��
%           ty��Y����ƽ�����ص����������ƽ��Ϊ��������ƽ��Ϊ��
%���������Img_translation��ƽ�ƺ�ͼ��,uint8��ʽ
%          TranslationLutX��ƽ�Ʋ��ұ�X 
%          TranslationLutY��ƽ�Ʋ��ұ�Y 
%    ʱ�䣺2017/11/16

%% init
[Hin,Win]=size(Img);  
Img_translation  = zeros(Hin,Win);    %����������  
TranslationLutX = zeros(Hin,Win);
TranslationLutY = zeros(Hin,Win);  
  
%% Translation  
for x=1:Win  
    for y=1:Hin  
        x0 =x-tx;  
        y0= y-ty;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  

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