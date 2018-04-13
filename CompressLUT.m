function CompressLUT(UnifyLutX,UnifyLutY)
[M0,N0] = size(UnifyLutX);

%删除全零行或者列
UnifyLutX_cut = UnifyLutX;
UnifyLutY_cut = UnifyLutY;
%删除全0行
UnifyLutX_cut(all(UnifyLutX_cut==0,2),:) = [];
UnifyLutY_cut(all(UnifyLutY_cut==0,2),:) = [];
%删除全0列
UnifyLutX_cut(:,all(UnifyLutX_cut==0,1)) = [];
UnifyLutY_cut(:,all(UnifyLutY_cut==0,1)) = [];

[M,N] = size(UnifyLutX_cut);
amount = M*N;
%% 压缩成512*512
if mod(M,2)==1&&mod(N,2)==1
    UnifyLutX_Interp1 = UnifyLutX_cut;
    UnifyLutY_Interp1 = UnifyLutY_cut;
elseif mod(M,2)==0&&mod(N,2)==1
    UnifyLutX_Interp1 = UnifyLutX_cut(1:end-1,:);
    UnifyLutY_Interp1 = UnifyLutY_cut(1:end-1,:);
elseif mod(M,2)==1&&mod(N,2)==0
    UnifyLutX_Interp1 = UnifyLutX_cut(:,1:end-1);
    UnifyLutY_Interp1 = UnifyLutY_cut(:,1:end-1);
else
    UnifyLutX_Interp1 = UnifyLutX_cut(1:end-1,1:end-1);
    UnifyLutY_Interp1 = UnifyLutY_cut(1:end-1,1:end-1);
end
[M1,N1] = size(UnifyLutX_Interp1);
UnifyLutX_Interp1(2:2:end,:) = 0;
UnifyLutX_Interp1(:,2:2:end) = 0;

UnifyLutY_Interp1(2:2:end,:) = 0;
UnifyLutY_Interp1(:,2:2:end) = 0;
for i = 1:2:M1-1
    for j = 1:2:N1-1
        XA = UnifyLutX_Interp1(i,j);
        XB = UnifyLutX_Interp1(i,j+2);
        XC = UnifyLutX_Interp1(i+2,j);
        XD = UnifyLutX_Interp1(i+2,j+2);
        UnifyLutX_Interp1(i,j+1) = round((XA+XB)/2);
        UnifyLutX_Interp1(i+1,j) = round((XA+XC)/2);
        UnifyLutX_Interp1(i+1,j+1) = round((XA+XB+XC+XD)/4);
        UnifyLutX_Interp1(i+1,j+2) = round((XB+XD)/2);
        UnifyLutX_Interp1(i+2,j+1) = round((XC+XD)/2);
        
        YA = UnifyLutY_Interp1(i,j);
        YB = UnifyLutY_Interp1(i,j+2);
        YC = UnifyLutY_Interp1(i+2,j);
        YD = UnifyLutY_Interp1(i+2,j+2);
        UnifyLutY_Interp1(i,j+1) = round((YA+YB)/2);
        UnifyLutY_Interp1(i+1,j) = round((YA+YC)/2);
        UnifyLutY_Interp1(i+1,j+1) = round((YA+YB+YC+YD)/4);
        UnifyLutY_Interp1(i+1,j+2) = round((YB+YD)/2);
        UnifyLutY_Interp1(i+2,j+1) = round((YC+YD)/2);

    end
end

Num_overrange = 0;
for i = 1:M1
    for j = 1:N1
        u_point_refer = UnifyLutX_cut(i,j);
        v_point_refer = UnifyLutY_cut(i,j);
        u_point_interp = UnifyLutX_Interp1(i,j);
        v_point_interp = UnifyLutY_Interp1(i,j);
        Distance = sqrt((u_point_interp-u_point_refer)^2+(v_point_interp-v_point_refer)^2);
        if Distance>=Threshold
            Num_overrange = Num_overrange+1;
        end
    end
end
disp(['超出阈值的个数为',num2str(Num_overrange)]);
disp(['超出阈值的比例为',num2str(Num_overrange/amount*100),'%']);

%% 压缩成256*256
Xend = M-1-4*(ceil(M/4)-1);
Yend = N-1-4*(ceil(N/4)-1);
UnifyLutX_Interp2 = UnifyLutX_cut(1:M-Xend,1:N-Yend);
UnifyLutY_Interp2 = UnifyLutY_cut(1:M-Xend,1:N-Yend);
[M2,N2] = size(UnifyLutX_Interp2);
for i=1:4:M2-4
    for j=1:4:N2-4
        UnifyLutX_Interp2(i+1:i+3,:) = 0;
        UnifyLutX_Interp2(:,j+1:j+3) = 0;
        UnifyLutY_Interp2(i+1:i+3,:) = 0;
        UnifyLutY_Interp2(:,j+1:j+3) = 0;
    end
end


 x = [1,5];
 y = [1,5];
 [X,Y] = meshgrid(x,y);
 xa = 1:5;
 ya = 1:5;
 [Xa,Ya] = meshgrid(xa,ya);
for i = 1:4:M2-1
    for j = 1:4:N2-1
        XA = UnifyLutX_Interp2(i,j);
        XB = UnifyLutX_Interp2(i,j+4);
        XC = UnifyLutX_Interp2(i+4,j);
        XD = UnifyLutX_Interp2(i+4,j+4);
        Z=[XA,XB;XC,XD];
        Za = interp2(X,Y,Z,Xa,Ya,'linear');
        UnifyLutX_Interp2(i:i+4,j:j+4) = round(Za);
        
        YA = UnifyLutY_Interp2(i,j);
        YB = UnifyLutY_Interp2(i,j+4);
        YC = UnifyLutY_Interp2(i+4,j);
        YD = UnifyLutY_Interp2(i+4,j+4);
        Z=[YA,YB;YC,YD];
        Za = interp2(X,Y,Z,Xa,Ya,'linear');
        UnifyLutY_Interp2(i:i+4,j:j+4) = round(Za);

    end
end

Num_overrange2 = 0;
for i = 1:M2
    for j = 1:N2
        u_point_refer = UnifyLutX_cut(i,j);
        v_point_refer = UnifyLutY_cut(i,j);
        u_point_interp = UnifyLutX_Interp2(i,j);
        v_point_interp = UnifyLutY_Interp2(i,j);
        Distance = sqrt((u_point_interp-u_point_refer)^2+(v_point_interp-v_point_refer)^2);
        if Distance>=Threshold
            Num_overrange2 = Num_overrange2+1;
        end
    end
end
disp(['超出阈值的个数为',num2str(Num_overrange2)]);
disp(['超出阈值的比例为',num2str(Num_overrange2/amount*100),'%']);

end