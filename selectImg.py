# Xiang Xiang (eglxiang@gmail.com), May 5, 2016, MIT license.

import os
from shutil import copyfile
import pdb

rootpath = '/localsata/xiang/YouTubeFaces/'
readname = 'detected_faces/'
savename = 'selected_faces/'


f = open('index.txt','r+')
count = 0
while True:
    count = count + 1
    print '{0:04}:'.format(count)
    # read line
    seqinfo = f.readline()
    print seqinfo
    seqinfo = seqinfo.rstrip('.mat\n')
    seqinfo = seqinfo.split('_')
    # get the person name
    person = ''
    for i in range(2, len(seqinfo)-1):
        person = person + seqinfo[i]+'_'
    person = person.rstrip('_')
    # create the person folder for output
    save_personfolder = rootpath + savename + person
    if not os.path.exists(save_personfolder):
        os.mkdir(save_personfolder, 0755)
    # get the sequence index
    seq = seqinfo[-1]
    # create the sequence folder for output
    save_seqfolder = save_personfolder + '/' + seq
    os.mkdir(save_seqfolder, 0755)

    # get the frame index
    idxset = f.readline()
    idxset = idxset.rstrip('\n')
    idxset = idxset.split(',')
    for i in range(len(idxset)):
        idx = int(idxset[i])
        # generate the current path
        readpath = rootpath + readname + person + '/' + seq + '/cropped_{0:03d}.jpg'.format(idx)
        # generate the save path
        savepath = save_seqfolder + '/cropped_{0:03d}.jpg'.format(idx)
        #pdb.set_trace()
        # copy the current image to a new directory
        copyfile(readpath, savepath)
