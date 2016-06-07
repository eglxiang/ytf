# Xiang Xiang (eglxiang@gmail.com), June 6, 2016, MIT license.
# Bash processing YFW: computing deep features.
#!/bin/bash

shopt -s dotglob

inputroot=".../YouTubeFaces/selected_faces/" # input folder path
outputroot=".../YouTubeFaces/features/" # output folder path
for dir in "$inputroot"*/
do
	echo "$dir"
	pename=${dir#$inputroot} # parameter substitution
	echo "$pename"
	#outdir=$outputroot$pename 
	#mkdir $outdir # comment if output directory have been created
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
					./classify_test VGG_FACE_deploy.prototxt VGG_FACE.caffemodel $arg3
					# note that arg3 is the argument variable defined above.
			fi
		done
	done
done
