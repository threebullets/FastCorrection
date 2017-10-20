clc
clear
row = 346;
col = 346;
fid=fopen('D:\work\Projects\matlab\Correction\output\create8row.raw', 'r');
data=fread(fid,'uint8');
fclose(fid);
Img =  (reshape(data,row,col))';
load loc;
[P,Q] =  size(loc);
Img1 = zeros(P,Q);
Img = Img';
n = 1;
 for i = 1 : P
     for j = 1 : Q
         if loc(i,j)>0      
             Img1(i,j) = Img(loc(i,j));
             n = n+1;
         end
     end
 end
 imshow(Img1)