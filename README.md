Experiments on Youtube Face in the Wild (YFW). The purpose of this documentary and repository is to make sure that you can replicate the same experiments as I did.

The idea of Linear Discriminant Analysis (LDA) is minimizing intra-class variance and maximizing inter-class variance, which is general. The adaptation of this idea to similarity learning is interesting, such as Discriminative Component Analysis (DCA), Local Fisher Discriminant Analysis (LFDA) and Logistic Discriminant-based Metric Learning (LDML). In ICCV 2009, Matthieu Guillaumin, Jakob Verbeek and Cordelia Schmid proposed this LDML approach in the paper titled "Is that you? Metric Learning Approaches for Face Identification" which has been cited by hundreds of papers. IDML was tested on the Labeled Face in the Wild (LFW) dataset at that time. Two year later, another dataset YFW (Youtube Face in the Wild) was built by using the 5,749 names of subjects included in the LFW dataset to search YouTube for videos of these same individuals. Then, a screening process reduced the original set of videos from the 18, 899 originally downloaded (3,345 individuals) to 3,425 videos of 1,595 subjects.

Video-based face recognition benchmark makes the subsequent solutions closer to a real-world face recognition solution. There should be a fair amount of interests to see the performance of LDML on YFW. As time goes by, Local Binary Feature (LBP) has been mostly replaced by deep learning features in the current experiments on either LFW or YFW. Following the same replacement of feature representation, this repository provides a tutorial to verify the metric learning approach of LDML on YFW.

Please download the full dataset from http://www.cs.tau.ac.il/~wolf/ytfaces/ and cite the original paper at CVPR'11 if you publish the experiments on that dataset.

Xiang Xiang (eglxiang@gmail.com), January 2016, MIT license.

=========================
Pre-processing.

Input:  YFW dataset - videos of hoslitic scenes containing faces.

Output: sampled dataset - selected frames of faces.

1. Face detection and cropping: cropFace.py and process.py.
The faces in the 'aligned_images_DB' folder of YFW are in the hoslitic scene. However, they have already been centered according to a certain aspect ratio. As a result, the cropping is straightforward.

2. Key face selection by pose quantization: sampleSelect.m and selectImg.py.
Training face selection by K-means clustering the poses which are rotation angles of roll, pitch and yaw, respectively. 
(1) Computing the rotation angles for each face video using existing 3D pose estimation method in OpenCV.
In particular, the 'headpose_DB' of YFW already contain the poses for each frame.
(2) Performs a frame-wise vector quantization which reduces the number of images required to represent the face from tens or hundreds to K (say, K = 9 for a K-means codebook), while preserving the overall diversity.
i) Clustering. Due to the randomness of K-means, you won't get exactly the same result every run.
ii) Selection. Selecting samples using distances from each point to every centroid. Outputing indexes to index.txt and copying images using selectImg.py.

3.  Split training and testing set.

There are 1,595 names in YFW.
(1) Splitting YFW by person.
Say, 798 for training and 797 for testing. Each person has at least 1 sequences. The issue is that the training person set non-overlaps with testing person set. As a result, we need an unsupervised metric learning algorithm, which means learning a metric from the testing data themselves. However, the way we learn the metric can be trained from the training data.

(2) Splitting each person's imagery by sequence. 
Only spliting those with at least 2 sequences (1,003 people). Taking 1 sequence of each person for training; the rest for testing.
The person with only 1 sequence (592 people) will only be used as testing data which will be used to verify the generalisation of the learned metric or simply as a non-of-them class.

=========================
Deep Feature Extraction.

Input: Selected faces.

Output: feature representations.

1. Deep face descriptor.
Grab codes from another repository of me - https://github.com/eglxiang/vgg_face.git and then use the main_seq.cpp which process all images in the directory specified in the argument. But before using it to compute VGG_Face features for each image, please first create the saving directory yourself. The program will write the feature vector of each face image into a txt file. A pre-complied binary in release mode is also provided (classify_test).

2. Bash processing for YFW.
(1) Read selected images for each sequence over all people in the YFW dataset.
(2) Use comuFea.sh to process a single sequence. You need to explicitly call the binary (either release or debug mode) such as ./bin/Release/classify_test VGG_FACE_deploy.prototxt VGG_FACE.caffemodel $arg3 where arg3 is the argument defined in the bash.

=========================
Pairwise metric learning. 

Multiple Instance Logistic Discriminant-based Metric Learning (MildML) is an extension of LDML for handling bag-level supervision, using the Multiple Instance Learning framework. Please download the program of MildML from http://lear.inrialpes.fr/people/guillaumin/code/MildML_0.1.tar.gz

function [ L b info ] = ldml_learn( X, Y, k, it, verbose, A0 )
Input: X is a (m x d) data matrix (m data points with d dimensions) and Y is a (m x 1) class labels (1 out of 1595)
where m is , d is 2622 (fc8 is chosen and 2622 corresponds to the number of identities in VGG Face's training set).
