Experiments on Youtube Face in the Wild (YFW).
Xiang Xiang (eglxiang@gmail.com), May 2016, MIT license.

Pre-processing.

1. Face detection and cropping: cropFace.py and process.py.
The faces in the 'aligned_images_DB' folder of YFW are in the hoslitic scene. However, they have already been centered according to a certain aspect ratio. As a result, the cropping is straightforward.

2. Key face selection by pose quantization: sampleSelect.m and 
Training face selection by k-means clustering the poses which are rotation angles of roll, pitch and yaw, respectively. 

(1) Computing the rotation angles for each face video using existing 3D pose estimation method in OpenCV.
- In particular, the 'headpose_DB' of YFW already contain the poses for each frame.

(2) Performs a frame-wise vector quantization which reduces the number of images required to represent the face from tens or hundreds to K (say, K = 9 for a K-means codebook), while preserving the overall diversity.

i) Clustering. Due tothe randomness of K-means, you won't get exactly the same result every run.

ii) Selection. Selecting samples using distances from each point to every centroid.
