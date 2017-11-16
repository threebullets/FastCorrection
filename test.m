Img=imread('checkerboard.bmp');
[Img_rotate,RotateLutX,RotateLutY] = imRotate_test(Img,5);
imshow(Img_rotate)