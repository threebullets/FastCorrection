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
angle = -5;
fh = 0.5;
fw = 0.5;
tx = 20;
ty = 40;
pivotH = 20;
pivotW = 40;
A = [80,0,40;0,80,40;0,0,1];
D = [0,0];
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
[Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img2,fh,fw,h1,w1);

%% Translation
[Img_translation,TranslationLutX,TranslationLutY] = imTranslation(Img_scaler,tx,ty);

%% Rotate
[Img_rotate,RotateLutX,RotateLutY] = imRotate_pivot(Img_translation,angle,pivotH,pivotW);
%% 生成总查找表并给出结果
[M,N] = size(Img_rotate);

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

dataout = zeros(M,N);
 for i = 1 : M
     for j = 1 : N
         if UnifyLutX(i,j)>0 && UnifyLutY(i,j)>0 && h2 >= UnifyLutX(i,j) && w2 >= UnifyLutY(i,j) 
             dataout(i,j) = Img2(UnifyLutX(i,j),UnifyLutY(i,j));
         end
     end
 end


    %对比图像
    subplot(141);     
        imshow(uint8(Img2));
        title('原图像');
    subplot(142);     
        imshow(uint8(Img1));
        title('目标图像');    
    subplot(143);
        imshow(uint8(Img_rotate));
        title('校正后');
    subplot(144);
        imshow(uint8(dataout));
        title('统一校正');     
        
%% 输出图片与查找表        
% imwrite(dataout,'D:\work\Projects\matlab\Correction\output\LutMethod.bmp');
% 
% [P,Q] = size(UnifyLutX);
% loc = zeros(P,Q);
% for i = 1 : P
%     for j = 1 :Q
%         if UnifyLutX(i,j)==0 || UnifyLutY(i,j)==0
%             loc(i,j) = 0;
%         else
%             loc(i,j) = (UnifyLutX(i,j) - 1) * 346 + (UnifyLutY(i,j) - 1);
%         end
%     end
% end
% coe(loc,'LutMethodloc');
% disp('已生成LutMethodloc.coe文件')
% toc

