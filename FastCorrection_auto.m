%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  auther:
%  Key Laboratory of Intelligent Perception and Image Understanding of Ministry 
%  of Education, International Research Center for Intelligent Perception and 
%  Computation, Xidian University, Xian 710071,China(e-mail:zelianwen@foxmail.com).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
if (exist(output_path,'dir')==0)%����ļ��в�����
    mkdir(output_path);
end
output_path = strcat(file_path,'output\');
%% read two images 
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select reference image',...
                          input_path);
image_1=imread(strcat(pathname,filename));
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select the image to be registered',...
                          input_path);
image_2=imread(strcat(pathname,filename));

%% ʹ����ͼ���Сһ��
% [h1,w1]=size(image_1);
% [h2,w2]=size(image_2);
% image_1_original = image_1;
% fh1 = h1/h2;
% fw1 = w1/w2;
% image_1 = imScaler(image_1,fh1,fw1);
%% Display the reference image and the image to be registered
figure;
subplot(1,2,1);
imshow(image_1);
title('Reference image');
subplot(1,2,2);
imshow(image_2);
title('Image to be registered');
%% make file for save images
if (exist('save_image','dir')==0)%����ļ��в�����
    mkdir('save_image');
end

t1=clock;%Start time
%% Convert input image format
[~,w1,num1]=size(image_1);
[~,~,num2]=size(image_2);
if(num1==3)
    image_11=rgb2gray(image_1);
else
    image_11=image_1;
end
if(num2==3)
    image_22=rgb2gray(image_2);
else
    image_22=image_2;
end

%Converted to floating point data between 0-1
image_11=im2double(image_11);
image_22=im2double(image_22);   

%% Define the constants used
sigma=1.6;%Bottom Gauss Pyramid scale
dog_center_layer=3;%Defines the DOG Pyramid intermediate layer, the default is 3
contrast_threshold_1=0.04;%Contrast threshold of reference image
contrast_threshold_2=0.04;%Contrast threshold of the image to be registered
edge_threshold=10;%Edge threshold
is_double_size=false;%Whether the image size is enlarged,the default is 'false',to get more points, set it to 'true'
change_form='similarity';%Select geometric transformation type,it can be 'similarity','affine'

%% The number of groups in Gauss Pyramid
nOctaves_1=num_octaves(image_11,is_double_size);
nOctaves_2=num_octaves(image_22,is_double_size);

%% Generation of the first layer of the Gauss scale image
image_11=create_initial_image(image_11,is_double_size,sigma);
image_22=create_initial_image(image_22,is_double_size,sigma);

%% Generating  Gauss Pyramid of reference image 
tic;
[gaussian_pyramid_1,gaussian_gradient_1,gaussian_angle_1]=...
build_gaussian_pyramid(image_11,nOctaves_1,dog_center_layer,sigma);                                                      
disp(['Reference image generation Gauss Pyramid spent time is��',num2str(toc),'s']);

%% Generating  DOG Pyramid of reference image 
tic;
dog_pyramid_1=build_dog_pyramid(gaussian_pyramid_1,nOctaves_1,dog_center_layer);
disp(['Reference image generation DOG Pyramid spent time is��',num2str(toc),'s']);
clear gaussian_pyramid_1;
 
%% Search for extreme points in the  DOG Pyramid of the reference image
tic;
[key_point_array_1]=find_scale_space_extream...
(...
dog_pyramid_1,...
nOctaves_1,...
dog_center_layer,...
contrast_threshold_1,...
sigma,...
edge_threshold,...
gaussian_gradient_1,...
gaussian_angle_1...
);
disp(['The extreme points of the reference image detection spend time is��',num2str(toc),'s']);
clear dog_pyramid_1;

 %% The feature point descriptor generation,Reference image
tic;
[descriptors_1,locs_1]=calc_descriptors(gaussian_gradient_1,gaussian_angle_1,.....
                                        key_point_array_1,is_double_size);
disp(['Reference image feature point descriptor generation spend time is��',num2str(toc),'s']); 
clear gaussian_gradient_1;
clear gaussian_angle_1;


%% Generating  Gauss Pyramid of the image to be registered
tic;
[gaussian_pyramid_2,gaussian_gradient_2,gaussian_angle_2]=...
build_gaussian_pyramid(image_22,nOctaves_2,dog_center_layer,sigma);                                                                                                  
disp(['The image to be registered generation Gauss Pyramid spent time is��',num2str(toc),'s']);

%% Generating  DOG Pyramid of the image to be registered
tic;
dog_pyramid_2=build_dog_pyramid(gaussian_pyramid_2,nOctaves_2,dog_center_layer);
disp(['The image to be registered generation DOG Pyramid spent time is����',num2str(toc),'s']);
clear gaussian_pyramid_2;

%% Search for extreme points int the DOG Pyramid of the image to be registered
tic;
[key_point_array_2]=find_scale_space_extream...
(...
dog_pyramid_2,...
nOctaves_2,...
dog_center_layer,...
contrast_threshold_2,...
sigma,...
edge_threshold,...
gaussian_gradient_2,...
gaussian_angle_2...
);
disp(['The extreme points of the image to be registered detection spend time is��',num2str(toc),'s']);
clear dog_pyramid_2;

%% The feature point descriptor generation,the image to be registered
tic;
[descriptors_2,locs_2]=calc_descriptors(gaussian_gradient_2,gaussian_angle_2,...
                       key_point_array_2,is_double_size);
disp(['The image to be registered feature point descriptor generation spend time is��',num2str(toc),'s']); 
clear gaussian_gradient_2;
clear gaussian_angle_2;

%% Calculation of geometric transformation parameters
tic;
[solution,~,cor1,cor2]=...
    match(image_2, image_1,descriptors_2,locs_2,descriptors_1,locs_1,change_form);
disp(['Feature point matching spend time is��',num2str(toc),'s']); 

tform=maketform('projective',solution');
[M,N,P]=size(image_1);
ff=imtransform(image_2,tform, 'XData',[1 N], 'YData',[1 M]);
button=figure;
subplot(1,2,1);
imshow(image_1);
title('Reference image');
subplot(1,2,2);
imshow(ff);
title('Image after registration');
str1=['.\save_image\','Results after registration','.jpg'];
saveas(button,str1,'jpg');
t2=clock;
disp(['Total spending time is��',num2str(etime(t2,t1)),'s']); 

%% Display the detected feature points on the image
[button1,button2]=showpoint_detected(image_1,image_2,locs_1,locs_2);
str1=['.\save_image\','Reference image detection point','.jpg'];
saveas(button1,str1,'jpg');
str1=['.\save_image\','Points detected in the image to be registered','.jpg'];
saveas(button2,str1,'jpg');

%% Image fusion
image_fusion(image_1,image_2,solution);
%% Calculating parameters : Scaling , Angle , TranslationX , TranslationY
ParMat = solution';
TranslationX = ParMat(3,1);
TranslationY = ParMat(3,2);
Scaling = sqrt(ParMat(1,1)^2+ParMat(1,2)^2);
Angle = acosd(ParMat(1,1)/Scaling);
disp(['The Scale ratio is��',num2str(Scaling)]); 
disp(['The Rotation angle is��',num2str(Angle),'degree']); 
disp(['The Translation in X direction is��',num2str(TranslationX),'pixel']); 
disp(['The Translation in Y direction is��',num2str(TranslationY),'pixel']);


%% ����ת��
A = [256,0,320;0,256,320;0,0,1];
D = [0,0];
angle = Angle;
tx = round(TranslationX);
ty = round(TranslationY);
pivotH = round(TranslationY);
pivotW = round(TranslationX);
fh = 1/Scaling;
fw = 1/Scaling;
%% Correction
[Imgout_LutMethod,Img_Tradition,UnifyLutX,UnifyLutY] = ...
    LutMethodDRTS(image_1,image_2,A,D,angle,fh,fw,tx,ty,pivotH,pivotW);
%% create lut
[Lut] = CreateLut(w1,UnifyLutX,UnifyLutY);
%% output LUT
Lut2coe(Lut,strcat('.\save_image\','LutMethodCoe'));
disp('������LutMethodCoe.coe�ļ�')


    %�Ա�ͼ��
    subplot(2,2,1);     
        imshow(uint8(image_1));
        title('ԭͼ��');
    subplot(2,2,2);     
        imshow(uint8(image_2));
        title('Ŀ��ͼ��');    
    subplot(2,2,3);
        imshow(uint8(Img_Tradition));
        title('У����');
    subplot(2,2,4);
        imshow(uint8(Imgout_LutMethod));
        title('ͳһУ��');     
        



