function [Lut] = CreateLut(W,UnifyLutX,UnifyLutY)


[P,Q] = size(UnifyLutX);
Lut = zeros(P,Q);
for i = 1 : P
    for j = 1 :Q
        if UnifyLutX(i,j)==0 || UnifyLutY(i,j)==0
            Lut(i,j) = 0;
        else
            Lut(i,j) = (UnifyLutX(i,j) - 1) * W + (UnifyLutY(i,j) - 1);
        end
    end
end

end