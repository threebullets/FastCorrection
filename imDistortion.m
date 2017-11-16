function [Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img,A,D)
%�������ܣ�����У��
%�������룺Img����У������ͼ��uint8��double��ʽ
%          A:����ڲΡ����У�
%               fx,fyΪ���࣬cx,cyΪ����λ��
%                   |fx 0 cx|
%                A= |0 fy cy|
%                   |0  0 1 |
%        D:����ϵ����D=[k1,k2]
% ���������Img_Distortion��У�������ͼ��,uint8��ʽ
%          DistortionX����ת���ұ�X 
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    [M,N] = size(Img);
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

    
Img_Distortion = zeros(M,N);    
for i = 1 : M
    for j = 1 : N
        if DistortionLutX(i,j)>0 && DistortionLutY(i,j)>0 && M >= DistortionLutX(i,j) && N >= DistortionLutY(i,j) 
            Img_Distortion(i,j) = Img(DistortionLutX(i,j),DistortionLutY(i,j));    
        end
    end
end

end