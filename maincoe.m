tic
clear;
clc;

LutMethodDRTS
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
mat2coe(loc,'LutMethodloc');
disp('已生成LutMethodloc.coe文件')
toc
