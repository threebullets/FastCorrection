 %%���ű��������淽������������һ��У������+��ת
%%�Ƚ�����ת�������ٽ��л������
%%��ת����Ϊ��ת��ʱ��-5�ȣ���agree=-5
%%����Ĳ�����[1��2]��ΪͰ�λ��䣬������ڱ�
%%��ֵ�㷨Ϊ���ڽ���ֵ��
%%ʱ�䣺2017/5/26
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%����Ϊ��ת����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle = -5;
img1 = imread('testimg.bmp');

[h,w]=size(img1);  
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
            img_rotate(x,y) = img1(x0,y0);  
        end  
    end  
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��ת��õ�����תͼ�������img_rotate
%%����Ϊ���䲿��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = [300, 0, 80; 0, 300, 80; 0, 0, 1 ];   %%�ڲ�
	D = [1, 2];                               %%�������
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    I_d = img_rotate;
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
    
lutx = zeros(M,N);
luty = zeros(M,N);
for i = 1 : M
    for j = 1 : N
        if u_d_int(i,j)>0 && v_d_int(i,j)>0 && M >= u_d_int(i,j) && N >= v_d_int(i,j) 
            lutx(i,j) = RotateLutX(u_d_int(i,j),v_d_int(i,j));
            luty(i,j) = RotateLutY(u_d_int(i,j),v_d_int(i,j));
    
        end
    end
end


    dataout = zeros(M,N);    %%dataoutΪ���ɵĻ���ͼ��
for i = 1 : M
    for j = 1 : N
        if lutx(i,j)>0 && luty(i,j)>0 && M >= lutx(i,j) && N >= luty(i,j) 
            dataout(i,j) = I_d_double(lutx(i,j),luty(i,j));
        end
    end
end

    %�Ա�ͼ��
    subplot(131);     
        imshow(img1);
        title('ԭͼ��');
    subplot(132);
         imshow(img_rotate);
        title('��ת��ͼ��');
    subplot(133);
         imshow(dataout);
        title('�ٻ����ͼ��');
 imwrite(img_rotate,'lutimg.bmp');

