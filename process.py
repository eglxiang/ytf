import cv2
import numpy as np

def crop(filename):
    img = cv2.imread(filename)
    h = img.shape[0] # index starts with 0
    w = img.shape[1]

    top   = np.floor(0.5*(h - h/2.5));
    bottom= np.ceil(0.5*(h + h/2.5));
    left  = np.floor(0.5*(w - w/2.5));
    right = np.ceil(0.5*(w + w/2.5));
    img_cropped = img[top:bottom,left:right,:];

    return img_cropped