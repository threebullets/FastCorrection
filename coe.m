function [ output_args ] = coe( input_args , str )
%���������ת��Ϊ.coe��ʽ�ļ����
%coe(����������.coe��ʽ�ļ����ļ���)

fid = fopen([str,'.coe'],'wt');
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

