/* Process all images in the directory specified in the argument.
Xiang Xiang (eglxiang@gmail.com), May 2016, MIT license.
Main functionality: compute VGG_Face features for each image.
*/

#define CPU_ONLY
#define SIN_INPUT % single sequence
#define CORR_METRIC

#include "Classifier.h"
#include <caffe/caffe.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <math.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>

using namespace caffe;
using namespace cv;
using namespace std;
//using namespace boost::python

int main(int argc, char** argv)
{
#ifdef SIN_INPUT
    // load image
    if (argc != 5)
    {
        cerr<<"Run a simple test sample using pretrained VGG face model. " << endl
            << "Usage: " << argv[0]
            << "deploy.prototxt network.caffemodel folderpath" << endl;
        return -1;
    }
    string model_file = argv[1];
    string trained_file = argv[2];
    Classifier classifier(model_file, trained_file);
    string rootpath =  argv[3]; //"/localsata/xiang/CMS/PartnormalizedFaces/registration/";
    cout << rootpath << endl;
    string foldername = argv[4];
    cout << foldername << endl;
    string inputname  = "selected_faces";
    string outputname = "feature";

    string inputfolderpath = rootpath + inputname + foldername;
    cout << inputfolderpath << endl;
    // list files in the folder
    DIR *dir = opendir(inputfolderpath.c_str());
    string imgName;
    struct dirent *ent;

    if (dir != NULL) {
        while ( (ent = readdir(dir)) != NULL ) {
            imgName = ent->d_name;
            //cout << imgName << endl;
            if (imgName.compare(".")!=0 && imgName.compare("..")!=0)
            {
                string aux;
                aux.append(inputfolderpath);
                aux.append("/");
                aux.append(imgName);
                //cout << aux << endl;
                Mat img = imread(aux, -1);
                if (! img.data) {
                    cout << "Could not open or find the image" << endl;
                    return -1;
                }
                int height = img.rows;
                int width = img.cols;

                // subtract the average face
                Mat avg(height, width, CV_8UC3, Scalar(93.5940,104.7624,129.1863));
                // Mat mean_img(height, width, CV_8UC3, Scalar(90,100,120)); //also works
                Mat image = img - avg;
                vector<float> output = classifier.Predict(image);

                // save feature to text file
                ofstream outfile;
                string outfilename = rootpath + outputname + foldername + "/" + imgName + ".txt";
                //cout << outfilename << endl;
                outfile.open(outfilename.c_str());
                for (vector<float>::const_iterator i = output.begin(); i != output.end(); ++i) {
                    outfile << *i << ' ';
                }
                outfile.close();

                //debug
                //cout<<endl<<endl<<endl<<"Features saved!"<<endl<<endl<<endl<<endl;
            }
        }
    }

    return 0;
#else
    if (argc != 5) {
        cerr << "Run a simple test sample using pre-trained VGG face model. " << endl
        << "Usage: " << argv[0]
        << "deploy.prototxt network.caffemodel imageA imageB" << endl;
        return -1;
    }
    string model_file = argv[1];
    string trained_file = argv[2];
    Classifier classifier(model_file, trained_file);
    string datapath = "/home/eglxiang/databases/FaceRecognition/YouTubeFaces/aligned_images_DB/";
    string fileA = argv[3];
    string fileApath = datapath + fileA;
    string fileB = argv[4];

    string fileBpath = datapath + fileB;
    cerr << "--------------------- Feature extraction for "<<fileA<<"-----------"<<endl;
    Mat imgA = imread(fileApath, -1);
    if (! imgA.data) {
        cout << "Could not open or find the image " << fileA << endl;
    }
    namedWindow("Display window 1", WINDOW_AUTOSIZE);
    imshow("Display window 1", imgA);
    int heightA = imgA.rows;
    int widthA = imgA.cols;

    Mat imgB = imread(fileBpath, -1);
    if (! imgB.data) {
        cout << "Could not open or find the image " << fileB << endl;
    }
    namedWindow("Display window 2", WINDOW_AUTOSIZE);
    imshow("Display window 2", imgB);
    int heightB = imgB.rows;
    int widthB = imgB.cols;

    // subtract the average face
    Mat avgA(heightA,widthA,CV_8UC3,Scalar(93.5940,104.7624,129.1863));
    Mat imageA = imgA - avgA;
    Mat avgB(heightB,widthB,CV_8UC3,Scalar(93.5940,104.7624,129.1863));
    Mat imageB = imgB - avgB;

    // foward in the network
    vector<float> outputA = classifier.Predict(imageA);
    vector<float> outputB = classifier.Predict(imageB);

    /*for (vector<float>::const_iterator i = outputA.begin(); i != outputA.end(); ++i) {
        cout << *i << ' ';
    }
    cout << endl << endl << endl;
    for (vector<float>::const_iterator j = outputB.begin(); j != outputB.end(); ++j) {
        cout << *j << ' ';
    }*/

    #ifdef CORR_METRIC
    // compute cosine similarity
    float in_prod = 0;
    for (int i=0; i<outputA.size(); i++)
        in_prod += outputA[i]*outputB[i];
    double sim = in_prod/(norm(outputA,NORM_L2)*norm(outputB,NORM_L2));
    cout << endl << "Similarity: "<< sim*100.0 << "%"<<endl;
    #else
    float sub = 0;
    float sub_norm_sq = 0;
    for (int i=0; i<outputA.size(); i++)
        sub = outputA[i] - outputB[i];
        sub_norm_sq += sub*sub;
    double sub_norm = sqrt(sub_norm_sq);
    cout << endl << "Difference: "<< sub_norm*100.0 << "%"<< endl;
    #endif // CORR_METRIC

    cvWaitKey(0);

#endif // TWO_INPUT
}
