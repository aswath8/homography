function [cartCoord] = homo_2_cart(homoCoord)
%UNHOMOGENIZE_COORDINATES 

    dimension = size(homoCoord, 2) - 1;
        
    %divide every row by the last entry in that row
    normCoord = bsxfun(@rdivide,homoCoord,homoCoord(:,end));
    cartCoord = normCoord(:,1:dimension);
end

