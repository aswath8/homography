function [ cameraCenter ] = get_cam_center( cameraMatrix )
    [~, ~, V] = svd(cameraMatrix);
    cameraCenter = V(:,end);
    cameraCenter = homo_2_cart(cameraCenter'); %unhomogenize the point
end

