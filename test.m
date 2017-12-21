close all;
clear all;
clc

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
image_1=imread(strcat(pathname,filename));
%% 
A = [256,0,320;0,256,320;0,0,1];
D = [0,0];
[Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(image_1,A,D);
imshow(uint8(Img_Distortion))