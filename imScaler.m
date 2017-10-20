function [Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img,MagnifyH,MagnifyW)
%%���ű��������ɲ�����ƽ��ͼ��
%%����Ϊtx,ty ,������x����������y����ע�������˳���෴
%%ʱ�䣺2017/6/30
[Hin,Win]=size(Img);
Hout = MagnifyH*Hin;     %��С����
Wout = MagnifyW*Hin;
fh = Hin/Hout;
fw = Win/Wout;
Img_scaler  = zeros(Hout,Wout);    %����������  
ScalerLutX = zeros(Hout,Wout);
ScalerLutY = zeros(Hout,Wout);  
  
for i=1:Hout  
    for j=1:Wout  
        i1 =i*fw;  
        j1= j*fh;      
          
        i1=round(i1);         %���ڽ���ֵ  
        j1=round(j1);         %���ڽ���ֵ  
        ScalerLutX(i,j) = i1;
        ScalerLutY(i,j) = j1;
        if i1>0 && j1>0&& Win >= i1&& Hin >= j1  
            Img_scaler(i,j) = Img(i1,j1);  
        end  
    end  
end  

end