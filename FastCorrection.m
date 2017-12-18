%{
-----------------------------------------------------------------------
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from liubing (threebullets).
In the event of publication, the following notice is applicable:
Copyright (C) 2017-20xx threebullets Corporation
The entire notice above must be reproduced on all authorized copies.
Author              :       liubing 
Email Address       :       15611662571@163.com
Filename            :       FastCorrection.v
Data                :       2017-12-18
Description         :       Fast correction for image registration.
Modification History    :   1)Modify the output location of .coe
                            2)Modify the readme file.

Data            By          Version         Change Description
=========================================================================
17/12/18        liubing       2.1               Modify
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
if (exist(output_path,'dir')==0)%����ļ��в�����
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read two images 
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select  visible image',...
                          input_path);
Img_visible=imread(strcat(pathname,filename));
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select infrared image',...
                          input_path);
Img_infrared=imread(strcat(pathname,filename));
%% Convert input image format
[h1,w1,num1]=size(Img_visible);
[h2,w2,num2]=size(Img_infrared);
if(num1==3)
    Img_visible=rgb2gray(Img_visible);
end
if(num2==3)
    Img_infrared=rgb2gray(Img_infrared);
end
%Converted to double
Img_visible=double(Img_visible);
Img_infrared=double(Img_infrared);   
%% Correction
[Imgout_LutMethod,Img_Tradition,UnifyLutX,UnifyLutY] = ...
    LutMethodDRTS(Img_visible,Img_infrared,A,D,angle,fh,fw,tx,ty,pivotH,pivotW);
%% create lut
[Lut] = CreateLut(w1,UnifyLutX,UnifyLutY);
%% output LUT
Lut2coe(Lut,strcat(output_path,'LutMethodCoe'));
disp('������LutMethodCoe.coe�ļ�')


    %�Ա�ͼ��
    subplot(141);     
        imshow(uint8(Img_infrared));
        title('ԭͼ��');
    subplot(142);     
        imshow(uint8(Img_visible));
        title('Ŀ��ͼ��');    
    subplot(143);
        imshow(uint8(Img_Tradition));
        title('У����');
    subplot(144);
        imshow(uint8(Imgout_LutMethod));
        title('ͳһУ��');     
        