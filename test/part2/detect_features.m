function [ r, c ] = detect_features(grayImg)
%use harris corner detector
    sigma = 2;
    thresh = 0.05;
    radius = 2;
    disp = 5;
    [~, r, c] = harris(grayImg, sigma, thresh, radius, disp);
end



