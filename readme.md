#  FastCorrection
## What is FastCorrection
In the non-coaxial image fusion optical system, when the uncooled infrared detector and the low-illumination CMOS detector image the same infinity scene, due to the nature of the detector and the mechanical error of the system assembly, Image is not exactly the same,  there is translation, rotation and scaling relationship between the two images, in addition, the image itself is also a distortion problem. Therefore, the system needs to be registered before image fusion, so that the infrared and low light images can be completely matched. According to the offset between the infrared image and the glimmer image, the program can correct the infrared image to a position that can match the glimmer image.
The offset of the infrared image can be solved from the PSO-SIFT program relative to the glimmer image. Rotation, translation and scaling parameters are determined from the offset, and look-up tables are generated based on these parameters. The Look-up table Mothed was used to obtain a corrected infrared image.This result is compared with the results obtained using the PSO-SIFT method. Thus verifying the feasibility of the LUT method.
Acknowledgment:
Thanks to the PSO-SIFT program from Github provided by zelianwen, which has given me great help.

## Files Introduction
FastCorrection_Manual : Manually enter the calibration parameters to get the corrected image.
FastCorrection_auto : Get offset and corrected image automatically.
LutMethodDRTS:Correct the input image, including distortion, scaling, translation and rotation correction, and output a unified correction matrix.
CreateLut:According to the unified correction matrix, get the corresponding look-up table.
Lut2coe : The lookup table is converted to coe format file output
imDistortion : Image distortion correction
imScaler : Image scaler correction
imTranslation : Image translation correction
imRotate : Image rotate correction
imRotate_pivot : Rotate at a point as the center of rotation
Checkerboard£ºProduce chessboard picture.

