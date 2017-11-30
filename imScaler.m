function [Img_scaler,ScalerLutX,ScalerLutY] = imScaler(Img,fh,fw,varargin)
% �������ܣ�����ͼ��
% �������룺Img��������ͼ��uint8��double��ʽ
%           fh���߷�������ϵ��
%           fw����������ϵ��
%           Notes:����ϵ��Ϊ�Ŵ����ĵ���������10*10ͼ������Ϊ20*20,��fh = 0.5;fw = 0.5
%           if ��Ҫ�޶����ͼ���С��must>=����ͼ���С���������ͼ�����Ͻ���ʾ�����ಿ��Ϊ�ڱߡ�
%           varargin{1}���߷������ͼ���С
%           varargin{2}���������ͼ���С
%���������Img_scaler�����ź�ͼ��,uint8��ʽ
%          ScalerLutX�����Ų��ұ�X 
%          ScalerLutY�����Ų��ұ�Y 
%    ʱ�䣺2017/11/16
%% init
Img = double(Img);
[inputH,inputW]=size(Img);
output_H = round(inputH/fh);    
output_W = round(inputW/fw);
if nargin == 5
        if output_H<=varargin{1} && output_W<=varargin{2}
            output_H = varargin{1};
            output_W = varargin{2};
        end
else
        disp('The number of imScaler''s input parameters of  is WRONG! ');
        return;
end
Img_scaler  = zeros(output_H,output_W);   
ScalerLutX = zeros(output_H,output_W);
ScalerLutY = zeros(output_H,output_W);  
%% Scaler  
for i=1:output_H  
    for j=1:output_W  
        i1 =i*fw;  
        j1= j*fh;      
        %���ڽ���ֵ��   
        i1=round(i1);          
        j1=round(j1);      
        
        if i1>0 && j1>0&& inputH >= i1&& inputW >= j1  
            ScalerLutX(i,j) = i1;
            ScalerLutY(i,j) = j1;
            Img_scaler(i,j) = Img(i1,j1);  
        end  
    end  
end  
%% output
Img_scaler = uint8(Img_scaler);
end