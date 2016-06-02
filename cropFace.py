import os
import cv2
import glob
import pdb

from process import crop

rootpath = '/localsata/xiang/YouTubeFaces/'
readname = 'aligned_images_DB/'
savename = 'detected_faces/'
lst_name = os.listdir(rootpath + readname)

#pdb.set_trace()
for personname in lst_name:
    read_personfolder = rootpath + readname + personname
    lst_idx = os.listdir(read_personfolder)
    save_personfolder = rootpath + savename + personname
    os.mkdir(save_personfolder, 0755)
    for seqidx in lst_idx:
        save_seqfolder = save_personfolder + '/' + seqidx
        os.mkdir(save_seqfolder, 0755)
        for (i, img_file) in enumerate(glob.iglob(read_personfolder + '/' + seqidx + '/' + '*.jpg')):
            img_cropped = crop(img_file)
            savepath = save_seqfolder + '/cropped_{0:03d}.jpg'.format(i)
            cv2.imwrite(savepath, img_cropped)
