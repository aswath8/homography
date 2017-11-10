function [ r1, c1, r2, c2 ] = detect_features( grayImg1, grayImg2 )
%use harris corner detector
    sigma = 2;
    thresh = 0.05;
    radius = 2;
    disp = 5;
    [~, r1, c1] = harris(grayImg1, sigma, thresh, radius, disp);
    [~, r2, c2] = harris(grayImg2, sigma, thresh, radius, disp);
end

