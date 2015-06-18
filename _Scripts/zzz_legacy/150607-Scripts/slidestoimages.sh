#!/bin/bash

####### What this is for #########
# Straight PDF documents are not really usable in most video editors.
# Since the primary goal in creating these slides is to use them to create
# educational videos, it's necessary to prep them for a video editor.
# Video editors can handle image files well, so that's what we need.
#
#
####### How to Use #########
# This script is extremely simple:
# Just call the script and give it the absolute path to the PDF file.
# It will churn through each frame in the PDF slide deck, and then output 
# them all to image files. Afterwards, it will move all of the image files
# to the folder 'slide_imgs_for_vid'. All done.
#
#
####### Requirements for Use #########
# This script requires 'ImageMagick' to work. It calls ImageMagick and
# that's what does the actual work.
#
# Not incredibly important, but for the image files to be moved correctly
# correctly, the folder 'slide_imgs_for_vid' must exist, and you must
# be using the normal Chipmunk Math directory structure (see the script 
# "folderbuilder.sh"). The PDF file (along with the TEX file that made it)
# should live in the top of each video lesson folder. This script assumes
# it's working off of that structure. If you are not, then you'll still
# wind up getting all the individual images, just the final move into a single
# folder will wind up not working.
#
# Also, the script assumes that the PDF has a file extension of .pdf in the
# first place. If it doesn't, ImageMagick will get confused and the script
# also assumes it can work from a file extension in the variables. But, 
# what an incredibly strange thing if you are converting a PDF without '.pdf'.
#
#
####### Notes #########
# The below script is designed with outputting 1920x1080 images, since that's
# the format the videos are currently designed around. If that changes, the values
# given to ImageMagick will need to change as well.
#
# There are some open questions: *What is the best image format to use?
# * Should we use supersampling? [See below for explanation]
# * If yes on supersampling, to what level?
#
# Currently, we're going with PNG as the output file format. It might be that there
# is a better choice, but this prevents JPG artifacts while still remaining at sane
# file sizes.
#
# We're also currently using supersampling. [That is, exporting higher res images via
# ImageMagick, then immediately scaling them down before actually writing them.]
# It's a bit unsure if it's actually worth it (more processing time, possible slight
# increase in visual quality), but a single ad hoc test seemed to indicate it was. While
# running time was increased by a factor of 4 or so, there was a slight improvement to
# how the font looked (less "jaggy-ness") and also, suprisingly, a 5-10% decrease in
# file size of the final output.
#
# Currently doing supersampling at double size (3840x2160), then scaling to 50%.
#
#
####### Understanding the script #########
# Only hard part here is to understand the call to ImageMagick. Here it is broken down:
	# 'convert': Call to ImageMagick to do conversion between types.
	# '-density': Sets density (dpi, I believe) for creating image.
		# A value of 304.762 (arrived at by experimentation) will, for slides made with
		# TeX in this way (at aspect ratio 16:9) create a 1920x1080 image
		# A doubled value of 609.524 creates a 3840x2160 for supersampling.
	# '-monitor': Tells the program to give progress monitoring.
	# <file being worked on>: This is the file ImageMagick is converting from.
	# '-resize': Causes the images to be sized down before being written.
		# This value is made in conjunction with above -density.
		# Currently set at doubled resolution, so we use 50% sizing.
	# <name for output>.<different file extension>: This gives the name and file type
		# that we want for the output. We've chosen PNG as our file type.



### Begin Script ###

absolutepath=$1 #Absolute path to the file, given as user input.


if [ $absolutepath ] #This just checks for existence of user input
	# Run script if user gave input
	then
	filename=$(basename $absolutepath) #This is the filename, WITH extension.
	namewithoutextension="${filename%.*}" #and WITHOUT extension.
	directoryalone=$(dirname $absolutepath) #Absolute path to containing directory.

	cd $directoryalone # Moves us to working in proper directory
		# IM can work outside of directory, but images are created in script folder


	### Call to ImageMagick ###
	convert -density 609.524 -monitor $filename -resize 50% $namewithoutextension.png

### Check for Normal Folder Structure and Move Files ###
if [ -d slide_imgs_for_vid ]
	then
		mv *.png slide_imgs_for_vid
		echo
		echo "Time elapsed (in seconds):   $SECONDS"
		echo
		echo "Job's done, Boss."
		echo "You can find the finished product in the 'slide_imgs_for_vid' folder."
		echo

	else
	echo
	echo
	echo "Time elapsed (in seconds):   $SECONDS"
	echo
	echo
	echo "Woah Boss." 
	echo
	echo "Looks like you're not working in the normal directory structure"
	echo "for Chipmunk Math. This script is designed to work with that structure."
	echo "If you don't know it, you can use the script folderbuilder.sh to make it."
	echo "While we're at it, the best way to use this script is to actually just"
	echo "point the script at the absolute path to the PDF you want to convert."
	echo "That assumes you're using the normal directory structure, but it's easiest."
	echo
	echo "Next time, use the normal Chipmunk Math directory structure and have this"
	echo "script target an absolute path. Trust me, Boss, you'll love it."
	echo
fi




	

############## No User Input ###############
# If user did not give input, abort and tell them to give input.
else
	echo 
	echo "This shell script needs user input to work."
	echo "Please try again in this format: ./NameOfScript AbsolutePathToFile"
	echo
fi