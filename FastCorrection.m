%{
-----------------------------------------------------------------------
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from liubing (threebullets).
In the event of publication, the following notice is applicable:
Copyright (C) 2013-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author              :       liubing 
Email Address       :       15611662571@163.com
Filename            :       FastCorrection.v
Data                :       2017-11-16
Description         :       Fast correction for image registration.
Modification History    :   1)Reorganized the main function'FastCorrection'.
                            2)Modified the imScaler function to make it
                            possible to set the center point of a rotated image with a certain point.
                            3)Modified the imTranslation function to make
                            it possible to set the size of the output image.
                            4)Added the introductory section of each
                            function.
Data            By          Version         Change Description
=========================================================================
17/11/16        liubing       1.7               modify
-------------------------------------------------------------------------
%}
%% 
clear
clc
%% input parameter
angle
fh
fw
tx
ty
pivotH
pivotW
A
D
%% data path
m_path = mfilename('fullpath');
slash_num = strfind(m_path,'\');
file_path = m_path(1:slash_num(end-1));
input_path = strcat(file_path,'input');
output_path = strcat(file_path,'output');
% make file for output path
if (exist(output_path,'dir')==0)%如果文件夹不存在
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read two images 
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select reference image',...
                          input_path);
Img1=imread(strcat(pathname,filename));
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select the image to be registered',...
                          input_path);
Img2=imread(strcat(pathname,filename));
%% Display the reference image and the image to be registered
figure;
subplot(1,2,1);
imshow(image_1);
title('Reference image');
subplot(1,2,2);
imshow(image_2);
title('Image to be registered');
%% Convert input image format
[h1,w1,num1]=size(Img1);
[h2,w2,num2]=size(Img2);
if(num1==3)
    Img1=rgb2gray(Img1);
end
if(num2==3)
    Img2=rgb2gray(Img2);
end
%Converted to double
Img1=double(Img1);
Img2=double(Img2);   
%% Distortion
[Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img2,A,D);
%% Scaler
[Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img_Distortion,fh,fw,h1,w1);

%% Translation
[Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img_scaler,tx,ty);

%% Rotate
[Img_rotate,RotateLutX,RotateLutY] = imRotate_pivot(Img_translation,angle,pivotH,pivotW);
%% 生成总查找表并给出结果
[M,N] = size(Img_Distortion);

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

dataout = zeros(P,Q);
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
         imshow(img_scaler);
         title('校正缩放');
    subplot(233);
         imshow(img_translation);
         title('校正平移');
    subplot(234);
         imshow(img_rotate);
         title('校正旋转');
    subplot(235);
        imshow(Img_Distortion);
        title('校正畸变');
    subplot(236);
        imshow(dataout);
        title('统一校正');     
        
        
imwrite(dataout,'D:\work\Projects\matlab\Correction\output\LutMethod.bmp');

[P,Q] = size(UnifyLutX);
loc = zeros(P,Q);
for i = 1 : P
    for j = 1 :Q
        if UnifyLutX(i,j)==0 || UnifyLutY(i,j)==0
            loc(i,j) = 0;
        else
            loc(i,j) = (UnifyLutX(i,j) - 1) * 346 + (UnifyLutY(i,j) - 1);
        end
    end
end
coe(loc,'LutMethodloc');
disp('已生成LutMethodloc.coe文件')
toc

