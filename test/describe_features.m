function [ featDescriptions ] = describe_features( img, radius, r, c )

    numFeat = length(r); %number of features
    featDescriptions = zeros(numFeat, (2 * radius + 1)^2);

    % matrix with a single 1 in the center and zeros all around it
    padHelper = zeros(2 * radius + 1); 
    padHelper(radius + 1, radius + 1) = 1;

    % use the pad Helper matrix to pad the img such that the border values
    % extend out by the radius
    paddedImg = imfilter(img, padHelper, 'replicate', 'full');

    %Extract the neighborhoods around the found features
    for i = 1 : numFeat
        % the indices held in r,c can be used as 
        %the top left corner of the neighborhood rather than its center
        rowRange = r(i) : r(i) + 2 * radius;
        colRange = c(i) : c(i) + 2 * radius;
        neighborhood = paddedImg(rowRange, colRange);
        flattenedFeatureVec = neighborhood(:);
        featDescriptions(i,:) = flattenedFeatureVec;
    end
    
    %Normalize all descriptors to have zero mean and unit standard deviation
    featDescriptions = zscore(featDescriptions')';
end

