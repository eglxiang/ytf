# Xiang Xiang (eglxiang@gmail.com), June 15, 2016.

#!/bin/bash

shopt -s dotglob

rootpath="/localsata/xiang/YouTubeFaces/"
inputfoldername="selected_faces"
outputfoldername="feature"
inputroot=$rootpath$inputfoldername
#echo "1$inputroot"
outputroot=$rootpath$outputfoldername
#echo "2$outputroot"
mkdir $outputroot
for dir in "$inputroot"/*
do
#	echo "3$dir"
	pename=${dir#$inputroot} # para substitution
#	echo "4$pename"
	outdir=$outputroot$pename
#	echo "5$outdir"
	mkdir $outdir
	for subdir in "$dir"/*
	do
#		echo "6$subdir"
		idname=${subdir#$dir}
#		echo "7$idname"
		outsubdir=$outputroot$pename$idname
#		echo "8$outsubdir"		
		mkdir $outsubdir
		arg3=${subdir#$inputroot}
		echo "$arg3"
		for file in "$subdir"/*
		do
			#echo "10$file"			
			if [[ -f $file ]]
				then 
					#echo "11$file"
					./bin/Release/classify_test VGG_FACE_deploy.prototxt VGG_FACE.caffemodel $rootpath $arg3
			fi
		done
	done
done

