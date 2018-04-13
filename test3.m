clear
clc
x=[1,5];
y=[1,5];
[X,Y] = meshgrid(x,y);
Z=[1,5;5,11];
xa = 1:5;
ya = 1:5;
[Xa,Ya] = meshgrid(xa,ya);
Za = interp2(X,Y,Z,Xa,Ya,'linear');