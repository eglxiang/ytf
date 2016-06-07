Experiments on Youtube Face in the Wild (YFW). Please download the full dataset from http://www.cs.tau.ac.il/~wolf/ytfaces/ and cite the original paper at CVPR'11 if you publish the experiments on that dataset.

Xiang Xiang (eglxiang@gmail.com), May 2016, MIT license.

=========================
Pre-processing.

Input:  YFW dataset - videos of hoslitic scenes containing faces.

Output: sampled dataset - selected frames of faces.

1. Face detection and cropping: cropFace.py and process.py.
The faces in the 'aligned_images_DB' folder of YFW are in the hoslitic scene. However, they have already been centered according to a certain aspect ratio. As a result, the cropping is straightforward.


2. Key face selection by pose quantization: sampleSelect.m and selectImg.py
Training face selection by k-means clustering the poses which are rotation angles of roll, pitch and yaw, respectively. 
(1) Computing the rotation angles for each face video using existing 3D pose estimation method in OpenCV.
In particular, the 'headpose_DB' of YFW already contain the poses for each frame.
(2) Performs a frame-wise vector quantization which reduces the number of images required to represent the face from tens or hundreds to K (say, K = 9 for a K-means codebook), while preserving the overall diversity.
i) Clustering. Due tothe randomness of K-means, you won't get exactly the same result every run.
ii) Selection. Selecting samples using distances from each point to every centroid. Outputing indexes to index.txt and copying images using selectImg.py.

=========================
Deep Feature Extration.

Input: Selected faces.

Output: feature representations.

1. Deep face descriptor.
Grab codes from another repository of me - https://github.com/eglxiang/vgg_face.git and then use the main_seq.cpp which process all images in the directory specified in the argument. But before using it to compute VGG_Face features for each image, please first create the saving directory yourself. The program will write the feature vector of each face image into a txt file. A pre-complied binary in release mode is also provided (classify_test).

2. Bash processing for YFW.
(1) Read selected images for each sequence over all people in the YFW dataset. 
(2) Use comuFea.sh to process a single sequence. You need to explicitly call the binary (either release or debug mode) such as ./bin/Release/classify_test VGG_FACE_deploy.prototxt VGG_FACE.caffemodel $arg3 where arg3 is the argument defined in the bash.
