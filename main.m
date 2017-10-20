%%本脚本用于用逆方法，将测试用一步校正畸变+旋转+平移+缩放
%%先进行旋转操作，再进行畸变操作
%%旋转参数为旋转逆时针-5度，即agree=-5
%%畸变的参数是[1，2]，为桶形畸变，会产生黑边
%%插值算法为最邻近插值法
%%时间：2017/5/26
clear;
clc;
img1 = imread('D:\work\Projects\matlab\rotate\output\create16.bmp');
[sh,sw]=size(img1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为缩放部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MagnifyH = 0.5;
MagnifyW = 0.5;
[Img_scaler,ScalerLutX,ScalerLutY] = imScaler(img1,MagnifyH,MagnifyW);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为平移部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx = 20;
ty = 20;
[Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img_scaler,tx,ty);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为旋转部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = -5;
[Img_rotate,RotateLutX,RotateLutY] = imRotate(Img_translation,angle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%旋转后得到的旋转图像矩阵是img_rotate
%%以下为畸变部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [300, 0, 150; 0, 300, 150; 0, 0, 1 ];   %%内参
D = [0.5, 0.5];                               %%畸变参数
[Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img_rotate,A,D);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%以下为统一校正
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M,N] = size(img_Distortion);
dataout = zeros(M,N);    %%dataout为生成的畸变图像


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


    %对比图像
    subplot(231);     
        imshow(img1);
        title('原图像');
    subplot(232);
         imshow(Img_scaler);
         title('校正缩放');
    subplot(233);
         imshow(Img_translation);
         title('校正平移');
    subplot(234);
         imshow(Img_rotate);
         title('校正旋转');
    subplot(235);
        imshow(Img_Distortion);
        title('校正畸变');
    subplot(236);
        imshow(dataout);
        title('统一校正');     
        
        
%  imwrite(dataout,'lutimg.bmp');

