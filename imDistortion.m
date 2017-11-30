function [Img_Distortion,DistortionLutX,DistortionLutY] = imDistortion(Img,A,D)
%函数功能：畸变校正
%函数输入：Img：待校正畸变图像，uint8或double格式
%           A:相机内参。其中，
%               fx,fy为焦距，cx,cy为主点位置
%                   |fx 0 cx|
%                A= |0 fy cy|
%                   |0  0 1 |
%        D:畸变系数，D=[k1,k2]
% 函数输出： Img_Distortion：校正畸变后图像,uint8格式
%           DistortionX：畸变查找表X 
%           DistortionY：畸变查找表Y 
    fx = A(1,1);
    fy = A(2,2);
    cx = A(1,3);
    cy = A(2,3);
    k1 = D(1);
    k2 = D(2);
    
    [M,N] = size(Img);
    I_r = zeros(M,N);

    %图像坐标系和矩阵的表示是相反的
    %[row,col] = find(X)，坐标按照列的顺序排列，这样好和reshape()匹配出响应的图像矩阵
    %[a1,a2]=find(a),找出a矩阵中非零元素所在行和列,并存在a1,a2中，（a1(i),a2(i)）即第i个非零元素的坐标
    %isnan(A)返回一个和A尺寸一样的数组，如果A中某个元素是NaN，则对应元素为1，否则为0
    [u,v] = find(~isnan(I_r));                                  
    % XYZc 摄像机坐标系的值，但是已经归一化了，因为没有乘比例因子
    %公式 s[u v 1]' = A*[Xc Yc Zc]' ，其中s为比例因子，不加比例因子，Zc就为1，所以此时的Xc相对于( Xc/Zc )
    %inv(A)求A的逆矩阵
    XYZc= inv(A)*[u v ones(length(u),1)]'; 
    % 此时的x和y是没有畸变的
    x = XYZc(1,:);
    y = XYZc(2,:);
    r2 = x.^2+y.^2;
    % x和y进行畸变的
    xp = x.*(1+k1*r2 + k2*r2.^2);
    yp = y.*(1+k1*r2 + k2*r2.^2);
    % (u, v) 对应的畸变坐标 (u_d, v_d)
    ud = fx*xp + cx;
    vd = fy*yp + cy;
    u_d = reshape(ud,size(I_r));
    v_d = reshape(vd,size(I_r));

 %%最邻近插值
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