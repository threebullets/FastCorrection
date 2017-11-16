%%生成棋盘�?
clear
clc
%%checkerboard(a,b,c),每个小方格的边长的像素数为a，纵轴方向上方格的个数为b，横轴方向上方格的个数为c
%%checkerboard总是产生�?��白，�?��灰的棋盘格，�?��多生成一半，再裁掉一�?
I = checkerboard(20,2,4);
[M N] = size(I);
I1 = I(:,1:N/2)*256;
I2 = ones(140,140)*128;
I2(21:100,41:120) = I1;
I2 = uint8(I2);
imshow(I2)
imwrite(I2,'D:\work\Projects\matlab\FastCorrection\src\checkerboard.bmp','bmp');


