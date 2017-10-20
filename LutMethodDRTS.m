%%���ű��������淽������������һ��У������+��ת+ƽ��+����
%%�Ƚ�����ת�������ٽ��л������
%%��ת����Ϊ��ת��ʱ��-5�ȣ���agree=-5
%%����Ĳ�����[1��2]��ΪͰ�λ��䣬������ڱ�
%%ƽ�Ʋ���Ϊ����20����20 (�����Ҹ�)
%%���Ų���Ϊ��СΪԭͼ��һ��
%%��ֵ�㷨Ϊ���ڽ���ֵ��
%%ʱ�䣺2017/5/26
clear;
clc;
tic
img1 = imread('D:\work\Projects\matlab\Correction\output\create8.bmp');
[sh,sw]=size(img1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ���Ų���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h0,w0]=size(img1);
h1 = 0.5*h0;     %��С����
w1 = 0.5*h0;
fh = h0/h1;
fw = w0/w1;
img_scaler  = zeros(h1,w1);    %����������  
ScalerLutX = zeros(h1,w1);
ScalerLutY = zeros(h1,w1);  
  
for x=1:w1  
    for y=1:h1  
        x0 =x*fw;  
        y0= y*fh;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        ScalerLutX(x,y) = x0;
        ScalerLutY(x,y) = y0;
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_scaler(x,y) = img1(x0,y0);  
        end  
    end  
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊƽ�Ʋ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx = 20;
ty = 20;

[h0,w0]=size(img_scaler);  
img_translation  = zeros(h0,w0);    %����������  
TranslationLutX = zeros(h0,w0);
TranslationLutY = zeros(h0,w0);  
  
  
for x=1:w0  
    for y=1:h0  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        TranslationLutX(x,y) = x0;
        TranslationLutY(x,y) = y0;
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_translation(x,y) = img_scaler(x0,y0);  
        end  
    end  
end  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ��ת����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = -5;


[h,w]=size(img_translation);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
w2=round(abs(cos_val)*w+h*abs(sin_val));  
h2=round(abs(cos_val)*h+w*abs(sin_val));  
img_rotate  = zeros(h2,w2);    %����������  
RotateLutX = zeros(h2,w2);
RotateLutY = zeros(h2,w2);  
  
  
for x=1:w2  
    for y=1:h2  
        x0 = uint32(x*cos_val + y*sin_val -0.5*w2*cos_val-0.5*h2*sin_val+0.5*w);  
        y0= uint32(y*cos_val-x*sin_val+0.5*w2*sin_val-0.5*h2*cos_val+0.5*h);      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        RotateLutX(x,y) = x0;
        RotateLutY(x,y) = y0;
        if x0>0 && y0>0&& w >= x0&& h >= y0  
            img_rotate(x,y) = img_translation(x0,y0);  
        end  
    end  
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ת��õ�����תͼ�������img_rotate
%%����Ϊ���䲿��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = [160, 0, 80; 0, 160, 80; 0, 0, 1 ];   %%�ڲ�
	D = [0.4, 0.4];                               %%�������
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    [M,N] = size(img_rotate);
    I_r = zeros(M,N);

    %ͼ������ϵ�;���ı�ʾ���෴��
    %[row,col] = find(X)�����갴���е�˳�����У������ú�reshape()ƥ�����Ӧ��ͼ�����
    %[a1,a2]=find(a),�ҳ�a�����з���Ԫ�������к���,������a1,a2�У���a1(i),a2(i)������i������Ԫ�ص�����
    %isnan(A)����һ����A�ߴ�һ�������飬���A��ĳ��Ԫ����NaN�����ӦԪ��Ϊ1������Ϊ0
    [u,v] = find(~isnan(I_r));                                  
    % XYZc ���������ϵ��ֵ�������Ѿ���һ���ˣ���Ϊû�г˱�������
    %��ʽ s[u v 1]' = A*[Xc Yc Zc]' ������sΪ�������ӣ����ӱ������ӣ�Zc��Ϊ1�����Դ�ʱ��Xc�����( Xc/Zc )
    %inv(A)��A�������
    XYZc= inv(A)*[u v ones(length(u),1)]'; 
    % ��ʱ��x��y��û�л����
    x = XYZc(1,:);
    y = XYZc(2,:);
    r2 = x.^2+y.^2;
    % x��y���л����
    xp = x.*(1+k1*r2 + k2*r2.^2);
    yp = y.*(1+k1*r2 + k2*r2.^2);
    % (u, v) ��Ӧ�Ļ������� (u_d, v_d)
    ud = fx*xp + cx;
    vd = fy*yp + cy;
    u_d = reshape(ud,size(I_r));
    v_d = reshape(vd,size(I_r));

 %%���ڽ���ֵ
    DistortionLutX = floor(u_d);
    DistortionLutY = floor(v_d);

    
img_Distortion = zeros(M,N);    
for i = 1 : M
    for j = 1 : N
        if DistortionLutX(i,j)>0 && DistortionLutY(i,j)>0 && M >= DistortionLutX(i,j) && N >= DistortionLutY(i,j) 
            img_Distortion(i,j) = img_rotate(DistortionLutX(i,j),DistortionLutY(i,j));    
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����ΪͳһУ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M,N] = size(img_Distortion);



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
 
 
 
dataout = zeros(P,Q);
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
         imshow(img_scaler);
         title('У������');
    subplot(233);
         imshow(img_translation);
         title('У��ƽ��');
    subplot(234);
         imshow(img_rotate);
         title('У����ת');
    subplot(235);
        imshow(img_Distortion);
        title('У������');
    subplot(236);
        imshow(dataout);
        title('ͳһУ��');     
        
        
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
disp('������LutMethodloc.coe�ļ�')
toc

