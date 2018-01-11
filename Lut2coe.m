function [ w ] = Lut2coe( input_args , output_filename )
%函数功能：把输入mat矩阵转换为.coe格式文件输出
%函数输入：input_args：输入mat矩阵 
%          output_filename：为输出.coe文件命名
%coe(输入矩阵，输出.coe格式文件的文件名)

fid = fopen([output_filename,'.coe'],'wt');
fprintf(fid,'memory_initialization_radix = 10;\nmemory_initialization_vector = ');

[M,N] = size(input_args);
sum = M * N;
yn = reshape(input_args',1,sum);

for i = 1 : sum-1
    if mod(i-1,N) == 0 
        fprintf(fid,'\n');
    end
    fprintf(fid,'%4d,',yn(i));
end

i = i + 1;
fprintf(fid,'%4d;',yn(i));
fclose(fid);
end

