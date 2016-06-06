#!/bin/bash
# Practicing writting shell script

shopt -s dotglob

inputroot="/localsata/xiang/YouTubeFaces/selected_faces/"
outputroot="/localsata/xiang/YouTubeFaces/features/"
for dir in "$inputroot"*/
do
	echo "$dir"
	pename=${dir#$inputroot} # para substitution
	echo "$pename"
	#outdir=$outputroot$pename
	#mkdir $outdir
	for subdir in "$dir"*/
	do
		echo "$subdir"
		idname=${subdir#$dir}
		echo "$idname"
		#outsubdir=$outputroot$pename/$idname
		#mkdir $outsubdir
		arg3=${subdir#$inputroot}
		echo "$arg3"
		for file in "$subdir"*
		do
			if [[ -f $file ]]
				then 
					#echo "$file"
					./classify_test VGG_FACE_deploy.prototxt VGG_FACE.caffemodel arg3
			fi
		done
	done
done
