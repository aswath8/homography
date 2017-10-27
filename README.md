The goal of this assignment is to implement robust homography and fundamental matrix estimation to

register pairs of images separated either by a 2D or 3D projective transformation.

1 Stitching pairs of images

The first step is to write code to stitch together a single pair of images. For this part, you will be working

with the following pair (click on the images to download the high-resolution versions):

1\. Load both images, convert to double and to grayscale.

2\. Detect feature points in both images. You can use the Harris corner detector code harris.m that we

provide or the blob detector you have developed as part of HW 2.

3\. Extract local neighborhoods around every keypoint in both images, and form descriptors simply by

"flattening" the pixel values in each neighborhood to one-dimensional vectors. Experiment with dif-

ferent neighborhood sizes to see which one works the best. If you're using your Laplacian detector, use

the detected feature scales to define the neighborhood scales.

4\. Compute distances between every descriptor in one image and every descriptor in the other image. You

can use dist2.m that we provide for fast computation of Euclidean distance. Alternatively, experiment

with computing normalized correlation, or Euclidean distance after normalizing all descriptors to have

zero mean and unit standard deviation. Optionally, feel free to experiment with SIFT descriptors.

The script find sift.m that we provide contains some basic code for computing SIFT descriptors of

circular regions, such as the ones returned by the detector from HW 2.

∗ Credit to Svetlana Lazebnik for this assignment.

1

5\. Select putative matches based on the matrix of pairwise descriptor distances obtained above. You can

select all pairs whose descriptor distances are below a specified threshold, or select the top few hundred

descriptor pairs with the smallest pairwise distances.

6\. Run RANSAC to estimate a homography mapping one image onto the other. Report the number of

inliers and the average residual for the inliers (squared distance between the point coordinates in one

image and the transformed coordinates of the matching point in the other image). Also, display the

locations of inlier matches in both images.

7\. Warp one image onto the other using the estimated transformation. To do this, you will need to learn

about maketform and imtransform functions.

8\. Create a new image big enough to hold the panorama and composite the two images into it. You can

composite by simply averaging the pixel values where the two images overlap. Your result should look

something like this (but hopefully with a more precise alignment):

9\. You should create color panoramas by applying the same compositing step to each of the color channels

separately (for estimating the transformation, it is sufficient to use grayscale images).

Tips and Details

- For RANSAC, a very simple implementation is sufficient. Use four matches to initialize the homography

in each iteration. You should output a single transformation that gets the most inliers in the course of

all the iterations. For the various RANSAC parameters (number of iterations, inlier threshold), play

around with a few "reasonable" values and pick the ones that work best. Refer to the October 13,

2017 lecture for details on RANSAC. For randomly sampling matches, you can use the randperm or

randsample functions.

- For details of homography fitting, you should review the October 13, 2017 lecture.

- In MATLAB, the solution to a nonhomogeneous linear least squares system AX=B is given by

X = A\B;

- Homography fitting calls for homogeneous least squares. The solution to the homogeneous least squares

system AX=0 is obtained from the SVD of A by the singular vector corresponding to the smallest

2

singular value:

[U,S,V]=svd(A); X = V(:,end);

For extra credit

- Extend your homography estimation to work on multiple images. You can use the data we provide,

consisting of three sequences consisting of three images each. For the "pier" sequence, sample output

can look as follows (although yours may be different if you choose a different order of transformations):

Alternatively, feel free to acquire your own images and stitch them.

Figure 2: Source of data and results: Arun Mallya

- Experiment with registering very "difficult" image pairs or sequences -- for instance, try to find a

modern and a historical view of the same location to mimic the kinds of composites found here. Or

try to find two views of the same location taken at different times of day, different times of year, etc.

Another idea is to try to register images with a lot of repetition, or images separated by an extreme

transformation (large rotation, scaling, etc.). To make stitching work for such challenging situations,

you may need to experiment with alternative feature detectors and/or descriptors, as well as feature

space outlier rejection techniques such as Lowe's ratio test.

- Try to implement a more complete version of a system for "Recognizing panoramas" -- i.e., a system

that can take as input a "pile" of input images (including possible outliers), figure out the subsets that

should be stitched together, and then stitch them together. As data for this, either use images you

take yourself or combine all the provided input images into one folder (plus, feel free to add outlier

images that do not match any of the provided ones).

- Implement bundle adjustment or global nonlinear optimization to simultaneously refine transformation

parameters between all pairs of images.

- Learn about and experiment with image blending techniques and panorama mapping techniques (cylin-

drical or spherical).

2 Fundamental Matrix Estimation and Triangulation

You will be using these two image pairs: assignment3 part2 data.zip provides the full size images,

matching points, camera matrices, and sample code.

1\. Load the image pair and matching points file into MATLAB (see sample code in the data file).

3

2\. Fit a fundamental matrix to the matching points. Use the sample code provided to visualize the

results. Implement both the normalized and the unnormalized algorithms (see October 6, 2017

lecture for the methods). In each case, report your residual, or the mean squared distance in pixels

between points in both images and the corresponding epipolar lines.

3\. Now use your putative match generation and RANSAC code from Part 1 to estimate fundamental

matrices without groundtruth matches. For this part, only use the normalized algorithm. Report the

number of inliers and the average residual for the inliers. In your report, compare the quality of the

result with the one you get from ground-truth matches.

4\. Load the camera matrices for the two images (they are stored as 3x4 matrices and can be loaded with

the load command, i.e.,

P1 = load('house1 camera.txt');

Find the centers of the two cameras. Use linear least squares to triangulate the position of each

matching pair of points given the two cameras (see page 50 and later of the October 2, 2017 lecture for

the method). Display the two camera centers and reconstructed points in 3D. Also report the residuals

between the observed 2D points and the projected 3D points in the two images.

Note: you do not need the camera centers to solve the triangulation problem. They are used just for

the visualization.

Note 2: it is sufficient to only use the provided ground-truth matches for this part. But if you wish,

feel free to also generate and compare results with the inlier matches you have found in item 3 above.

Tips and Details

- For fundamental matrix estimation, don't forget to enforce the rank-2 constraint. This can be done by

taking the SVD of F, setting the smallest singular value to zero, and recomputing F.

- October 6, 2017 lecture shows two slightly different linear least squares setups for estimating the

fundamental matrix (one involves a homogeneous system and one involves a non-homogeneous system).

You may want to compare the two and determine which one is better in terms of numerics.

- Recall that the camera centers are given by the null spaces of the matrices. They can be found by

taking the SVD of the camera matrix and taking the last column of V.

- For triangulation with linear least squares, it is not necessary to use data normalization (in my imple-

mentation, normalization made very little difference for this part).

- Plotting in 3D can be done using the plot3 command. Use the axis equal option to avoid au-

tomatic nonuniform scaling of the 3D space. To show the structure clearly, you may want to include

snapshots from several viewpoints. In the past, some students have also been able to produce animated

GIF's, and those have worked really well.

Grading checklist

1\. Homography estimation:

(a) Describe your solution, including any interesting parameters or implementation choices for feature

extraction, putative matching, RANSAC, etc.

4

(b) For the uttower pair provided, report the number of homography inliers and the average residual

for the inliers (squared distance between the point coordinates in one image and the transformed

coordinates of the matching point in the other image). Also, display the locations of inlier matches

in both images.

(c) Display the final result of your stitching.

2\. Fundamental matrix estimation:

(a) For both image pairs, for both unnormalized and normalized estimation using ground truth

matches, display your result and report your residual.

(b) For both image pairs, for normalized estimation without ground truth matches, display your result

and report your number of inliers and residual for inliers.

(c) For both image pairs, visualize 3D camera centers and triangulated 3D points.