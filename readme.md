#  FastCorrection
对微光与红外图像融合前的配准问题进行快速校正.

## What is FastCorrection
对红外图像进行畸变、缩放、平移和旋转校正，使其能和微光图像完成配准。

## Program structure and introduction
FastCorrection : 主程序
LutMethodDRTS : 对输入图像进行畸变、缩放、平移和旋转校正，并输出统一校正矩阵
CreateLut : 根据统一校正矩阵获得与SRAM地址对应的LUT查找表
Lut2coe : 将LUT查找表转换为coe格式文件输出
imDistortion : 畸变校正
imScaler : 缩放变换
imTranslation : 平移变换
imRotate : 以图像中心为旋转中心，进行旋转变换
imRotate_pivot : 自定某一点为旋转中心，进行旋转变换

Checkerboard：产生棋盘格图片，生成checkerboard.bmp


