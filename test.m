load LutMethod
fid = fopen('LutMethod.txt','w');
fprintf(fid,'%g\t',Lut);
fclose(fid);