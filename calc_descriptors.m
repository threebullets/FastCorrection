function [descriptors,locs]=calc_descriptors...
(gaussian_gradient,...%% Gradient magnitude
gaussian_angle,...%% Gradient angle
key_point_array,...%% feature points
is_double_size)

%locs=[row,col,scale��angle��Gradient magnitude��group��layer]

LOG_POLAR_DESCR_WIDTH=8;
LOG_POLAR_HIST_BINS=8;

M=size(key_point_array,2);
locs=zeros(M,7);

d=LOG_POLAR_DESCR_WIDTH;
n=LOG_POLAR_HIST_BINS;
descriptors=zeros(M,(2*d+1)*n);

for i=1:1:M
kpt=key_point_array(i);
octaves=kpt.octaves;
layer=kpt.layer;
y=kpt.y/(2^(octaves-1));
x=kpt.x/(2^(octaves-1));
main_angle=kpt.angle;
scale=kpt.size/(2^(octaves-1));

temp_gradient=gaussian_gradient{octaves,layer-1};
temp_angle=gaussian_angle{octaves,layer-1};
descriptors(i,:)=calc_log_polar_descriptor(temp_gradient,temp_angle,...
                                    round(x),round(y),scale,main_angle,d,n);
if(is_double_size==true)
    locs(i,1)=kpt.y/2;
    locs(i,2)=kpt.x/2;
elseif(is_double_size==false)
    locs(i,1)=kpt.y;
    locs(i,2)=kpt.x; 
end
locs(i,3)=kpt.size;
locs(i,4)=kpt.angle;
locs(i,5)=kpt.gradient;
locs(i,6)=kpt.octaves;
locs(i,7)=kpt.layer;
end

end





