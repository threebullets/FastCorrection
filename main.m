%%���ű��������淽������������һ��У������+��ת+ƽ��+����
%%�Ƚ�����ת�������ٽ��л������
%%��ת����Ϊ��ת��ʱ��-5�ȣ���agree=-5
%%����Ĳ�����[1��2]��ΪͰ�λ��䣬������ڱ�
%%��ֵ�㷨Ϊ���ڽ���ֵ��
%%ʱ�䣺2017/5/26
clear;
clc;
img1 = imread('D:\work\Projects\matlab\rotate\output\create16.bmp');
[sh,sw]=size(img1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ���Ų���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MagnifyH = 0.5;
MagnifyW = 0.5;
[Img_scaler,ScalerLutX,ScalerLutY] = imScaler(img1,MagnifyH,MagnifyW);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊƽ�Ʋ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx = 20;
ty = 20;
[Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img_scaler,tx,ty);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ��ת����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = -5;
[Img_rotate,RotateLutX,RotateLutY] = imRotate(Img_translation,angle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ת��õ�����תͼ�������img_rotate
%%����Ϊ���䲿��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [300, 0, 150; 0, 300, 150; 0, 0, 1 ];   %%�ڲ�
D = [0.5, 0.5];                               %%�������
[Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img_rotate,A,D);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����ΪͳһУ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M,N] = size(img_Distortion);
dataout = zeros(M,N);    %%dataoutΪ���ɵĻ���ͼ��


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
 
 
 

 for i = 1 : P
     for j = 1 : Q
         if UnifyLutX(i,j)>0 && UnifyLutY(i,j)>0 && sh >= UnifyLutX(i,j) && sw >= UnifyLutY(i,j) 
             dataout(i,j) = img1(UnifyLutX(i,j),UnifyLutY(i,j));
         end
     end
 end


    %�Ա�ͼ��
    subplot(231);     
        imshow(img1);
        title('ԭͼ��');
    subplot(232);
         imshow(Img_scaler);
         title('У������');
    subplot(233);
         imshow(Img_translation);
         title('У��ƽ��');
    subplot(234);
         imshow(Img_rotate);
         title('У����ת');
    subplot(235);
        imshow(Img_Distortion);
        title('У������');
    subplot(236);
        imshow(dataout);
        title('ͳһУ��');     
        
        
%  imwrite(dataout,'lutimg.bmp');

