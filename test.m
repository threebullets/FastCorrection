clc
clear
Threshold = 5;
load LutMethod
[M0,N0] = size(Lut);

%ɾ��ȫ���л�����
Lut_cut = Lut;
%ɾ��ȫ0��
Lut_cut(all(Lut_cut==0,2),:) = [];
%ɾ��ȫ0��
Lut_cut(:,all(Lut_cut==0,1)) = [];
%��ɾһȦ
Lut_cut = Lut_cut(2:end-1,2:end-1);
[M,N] = size(Lut_cut);
amount = M*N;

Lut_Interp = Lut_cut;
Lut_Interp(2:2:end,:) = 0;
Lut_Interp(:,2:2:end) = 0;
for i = 1:2:M-3
    for j = 1:2:N-3
        A = Lut_Interp(i,j);
        B = Lut_Interp(i,j+2);
        C = Lut_Interp(i+2,j);
        D = Lut_Interp(i+2,j+2);
%         if A~=0&&B~=0
        Lut_Interp(i,j+1) = (A+B)/2;
        Lut_Interp(i+1,j) = (A+C)/2;
        Lut_Interp(i+1,j+1) = (A+B+C+D)/4;
        Lut_Interp(i+1,j+2) = (B+D)/2;
        Lut_Interp(i+2,j+1) = (C+D)/2;
%         end
    end
end

Num_overrange = 0;
for i = 1:M
    for j = 1:N
        point_refer = Lut_cut(i,j);
        u_point_refer = fix(point_refer/N0)+1;
        v_point_refer = mod(point_refer,N0)+1;
        point_interp = Lut_Interp(i,j);
        u_point_interp = fix(point_interp/N0)+1;
        v_point_interp = mod(point_interp,N0)+1;
        Distance = sqrt((u_point_interp-u_point_refer)^2+(v_point_interp-v_point_refer)^2);
        if Distance>=Threshold
            Num_overrange = Num_overrange+1;
        end
    end
end
disp(['������ֵ�ĸ���Ϊ',num2str(Num_overrange)]);
disp(['������ֵ�ı���Ϊ',num2str(Num_overrange/amount*100),'%']);