%%���ű��������ɲ����û���+��תͼ���Ƚ��л���������ٽ�����ת����
%%����Ĳ�����[-1��-2]��Ϊ���λ��䣬�޺ڱ�
%%��ת����Ϊ��ת��ʱ��5�ȣ���agree=5
%%ƽ�Ʋ���-20��-20,��������20
%%����Ϊԭ������ 
%%��ֵ�㷨Ϊ���ڽ���ֵ��
%%ʱ�䣺2017/5/26
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ���䲿��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = [160, 0, 80; 0, 160, 80; 0, 0, 1 ];   %%�ڲ�
	D = [-0.4, -0.4];                               %%�������
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    I_d = imread('D:\work\Projects\matlab\Correction\output\checkerboard.bmp');
    I_d_double = im2double(I_d);
    [M N] = size(I_d_double);
    I_r = zeros(M,N);

    %ͼ������ϵ�;���ı�ʾ���෴��
    %[row,col] = find(X)�����갴���е�˳�����У������ú�reshape()ƥ�����Ӧ��ͼ�����
    %[a1,a2]=find(a),�ҳ�a�����з���Ԫ�������к���,������a1,a2�У���a1(i),a2(i)������i������Ԫ�ص�����
    %isnan(A)����һ����A�ߴ�һ�������飬���A��ĳ��Ԫ����NaN�����ӦԪ��Ϊ1������Ϊ0
    [u v] = find(~isnan(I_r));                                  

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
    u_d_int = floor(u_d);
    v_d_int = floor(v_d);
    img_distortion = zeros(M,N);    %%dataoutΪ���ɵĻ���ͼ��
for i = 1 : M
    for j = 1 : N
        if u_d_int(i,j)>0 && v_d_int(i,j)>0 && M >= u_d_int(i,j) && N >= v_d_int(i,j) 
            img_distortion(i,j) = I_d_double(u_d_int(i,j),v_d_int(i,j));
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�����õ��Ļ���ͼ�������img_distortion
%%����Ϊ��ת����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = 5;
img1 = img_distortion;

[h,w]=size(img1);  
radian=angle/180*pi;  
cos_val = cos(radian);  
sin_val = sin(radian);  
  
w2=round(abs(cos_val)*w+h*abs(sin_val));  
h2=round(abs(cos_val)*h+w*abs(sin_val));  
img_rotate  = zeros(h2,w2);    %����������  
  
  
for x=1:w2  
    for y=1:h2  
        x0 = uint32(x*cos_val + y*sin_val -0.5*w2*cos_val-0.5*h2*sin_val+0.5*w);  
        y0= uint32(y*cos_val-x*sin_val+0.5*w2*sin_val-0.5*h2*cos_val+0.5*h);      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        if x0>0 && y0>0&& w >= x0&& h >= y0  
            img_rotate(x,y) = img1(x0,y0);  
        end  
    end  
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ת��õ�����תͼ�������img_rotate
%%����Ϊƽ�Ʋ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%���ű��������ɲ�����ƽ��ͼ��
%%����Ϊtx,ty ,������x����������y����ע�������˳���෴
%%ʱ�䣺2017/6/30

tx = -20;
ty = -20;
img1 = img_rotate;
[h0,w0]=size(img1);  
img_translation  = zeros(h0,w0);    %����������  
  
  
for x=1:w0  
    for y=1:h0  
        x0 =x+tx;  
        y0= y+ty;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_translation(x,y) = img1(x0,y0);  
        end  
    end  
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%ƽ�ƺ�õ���ͼ�������img_translation
%%����Ϊ���Ų���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%���ű��������ɲ�����ƽ��ͼ��
%%����Ϊtx,ty ,������x����������y����ע�������˳���෴
%%ʱ�䣺2017/6/30


img1 = img_translation;
[h0,w0]=size(img1);
h1 = 2*h0;
w1 = 2*w0;

fh = h0/h1;
fw = w0/w1;
img_scaler  = zeros(h1,w1);    %����������  
  
  
for x=1:w1  
    for y=1:h1  
        x0 =x*fw;  
        y0= y*fh;      
          
        x0=round(x0);         %���ڽ���ֵ  
        y0=round(y0);         %���ڽ���ֵ  
        if x0>0 && y0>0&& w0 >= x0&& h0 >= y0  
            img_scaler(x,y) = img1(x0,y0);  
        end  
    end  
end  




    %�Ա�ͼ��
    subplot(231);     
        imshow(I_d_double);
        title('ԭͼ��');
    subplot(232);
         imshow(img_distortion);
         title('�����');
    subplot(233);
         imshow(img_rotate);
         title('��ת��');
    subplot(234);
         imshow(img_translation);
         title('ƽ�ƺ�');
    subplot(235);
        imshow(img_scaler);
        title('���ź�');
        
imwrite(img_scaler,'D:\work\Projects\matlab\Correction\output\create8.bmp');

