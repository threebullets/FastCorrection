function [Imgout_LutMethod,Img_Tradition,UnifyLutX,UnifyLutY] = LutMethodDRTS(Img_visible,Img_infrared,A,D,angle,fh,fw,tx,ty,pivotH,pivotW)
%%���ű��������淽������������һ��У������+��ת+ƽ��+����
%%�Ƚ�����ת�������ٽ��л������
%%��ת����Ϊ��ת��ʱ��-5�ȣ���agree=-5
%%����Ĳ�����[1��2]��ΪͰ�λ��䣬������ڱ�
%%ƽ�Ʋ���Ϊ����20����20 (�����Ҹ�)
%%���Ų���Ϊ��СΪԭͼ��һ��
%%��ֵ�㷨Ϊ���ڽ���ֵ��
%%ʱ�䣺2017/5/26
[h1,w1]=size(Img_visible);
[h2,w2]=size(Img_infrared);
%% Distortion
[Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img_infrared,A,D);
%% Scaler
[Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img_Distortion,fh,fw,h1,w1);

%% Translation
[Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img_scaler,tx,ty);

%% Rotate
[Img_Tradition,RotateLutX,RotateLutY] = imRotate_pivot(Img_translation,angle,pivotH,pivotW);
%% �����ܲ��ұ��������
[M,N] = size(Img_Tradition);

[P,Q] = size(TranslationLutX);
temp1X = zeros(P,Q);
temp1Y = zeros(P,Q);
for i = 1 : P
    for j = 1 : Q
        if RotateLutX(i,j)>0 && RotateLutY(i,j)>0 && P >= RotateLutX(i,j) && Q >= RotateLutY(i,j)  
            temp1X(i,j) = TranslationLutX(RotateLutX(i,j),RotateLutY(i,j));
            temp1Y(i,j) = TranslationLutY(RotateLutX(i,j),RotateLutY(i,j));
        end
    end
end


[P,Q] = size(ScalerLutX);
temp2X = zeros(P,Q);
temp2Y = zeros(P,Q);
for i = 1 : P
    for j = 1 : Q
        if temp1X(i,j)>0 && temp1Y(i,j)>0 && P >= temp1X(i,j) && Q >= temp1Y(i,j)  
            temp2X(i,j) = ScalerLutX(temp1X(i,j),temp1Y(i,j));
            temp2Y(i,j) = ScalerLutY(temp1X(i,j),temp1Y(i,j));
        end
    end
end

[P,Q] = size(DistortionLutX);
UnifyLutX = zeros(M,N);
UnifyLutY = zeros(M,N);
for i = 1 : M
    for j = 1 : N
        if temp2X(i,j)>0 && temp2Y(i,j)>0 && P >= temp2X(i,j) && Q >= temp2Y(i,j)  
            UnifyLutX(i,j) = DistortionLutX(temp2X(i,j),temp2Y(i,j));
            UnifyLutY(i,j) = DistortionLutY(temp2X(i,j),temp2Y(i,j));      
        end
    end
end

Imgout_LutMethod = zeros(M,N);
 for i = 1 : M
     for j = 1 : N
         if UnifyLutX(i,j)>0 && UnifyLutY(i,j)>0 && h2 >= UnifyLutX(i,j) && w2 >= UnifyLutY(i,j) 
             Imgout_LutMethod(i,j) = Img_infrared(UnifyLutX(i,j),UnifyLutY(i,j));
         end
     end
 end

