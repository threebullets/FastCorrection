function [Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img,MagnifyH,MagnifyW)
%%本脚本用于生成测试用平移图像
%%参数为tx,ty ,横轴是x方向，纵轴是y方向，注意和行列顺序相反
%%时间：2017/6/30
[Hin,Win]=size(Img);
Hout = MagnifyH*Hin;     %缩小两倍
Wout = MagnifyW*Hin;
fh = Hin/Hout;
fw = Win/Wout;
Img_scaler  = zeros(Hout,Wout);    %像素是整数  
ScalerLutX = zeros(Hout,Wout);
ScalerLutY = zeros(Hout,Wout);  
  
for i=1:Hout  
    for j=1:Wout  
        i1 =i*fw;  
        j1= j*fh;      
          
        i1=round(i1);         %最邻近插值  
        j1=round(j1);         %最邻近插值  
        ScalerLutX(i,j) = i1;
        ScalerLutY(i,j) = j1;
        if i1>0 && j1>0&& Win >= i1&& Hin >= j1  
            Img_scaler(i,j) = Img(i1,j1);  
        end  
    end  
end  

end