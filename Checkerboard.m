%%生成棋盘�?
clear
clc
%%checkerboard(a,b,c),每个小方格的边长的像素数为a，纵轴方向上方格的个数为b，横轴方向上方格的个数为c
%%checkerboard总是产生�?��白，�?��灰的棋盘格，�?��多生成一半，再裁掉一�?
I = checkerboard(20,8,16);
[M N] = size(I);
I1 = I(:,1:N/2);
imshow(I1)
imwrite(I1,'D:\work\Projects\matlab\rotate\output\checkerboard16.bmp','bmp');

