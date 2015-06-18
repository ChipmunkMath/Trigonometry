#!/bin/bash

# ###### What This Is For #########
# This shell script is designed to create animations in conjunction with GLE.
# It is designed to work with the GLE file templates built for animation.
# You can find those templates in the '_Templates' directory at the top of course.
#
# When correctly used, this will produce a large number of image files in sequence.
# This sequence of images can be tossed into a video editor to create an
# animation. Alternatively, you can use a program like ImageMagick to create an 
# animated GIF. In any case, this script produces the raw frames for later use.
#
#
# ###### How to Use #########
# This script is fairly simple. Call it and give the following two inputs:
# 1) The absolute path to the GLE file being animated.
# 2) Total number of frames ('framecount') for the animation.
#
# It will process the GLE file on each frame, spitting out each frame image.
# A folder will then be created one directory above in 'animations', and
# all the frame images will be placed inside that new folder. The folder will be named
# the same as the GLE file being processed.
#
# Note that the above assumes you are working in the normal Chipmunk Math directory
# structure (see the template "folderbuilder.sh"). If you aren't for some reason, it
# will warn you of that fact, but still collect the images into a single folder.
# That folder will be placed in the same directory as the GLE file being processed.
# The folder will be named 'animation-<GLE file name>'.
#
# If you have previously run the animation and have pre-existing images for a given
# GLE animation file, this script will simply overwrite them. If you change the
# framecount to a lower value than used on previous animation runs, you'll wind
# up having extra image files that are no longer in sequence with the animation.
# You'll be warned in this case, but cleaning them up is for you to deal with.
#
#
# ###### Requirements for Use #########
# This script requires GLE to be installed and usable from the command line.
#
# This script needs to be used in concert with an appropriately designed GLE file.
# All of the GLE templates that say 'animation' in their filename have this design
# in mind and should work out of the box with this script.
#
# This script assumes that you are working within a Chipmunk Math directory structure.
# If you are not, it will still work, but not as cleanly. See above for more.
#
# Some of the commands given assume that you are working exclusively with the PNG
# file format for your images. If you want to work with a different filetype, you'll
# need to change things appropriately. [But PNG is probably the best choice for our
# purposes: plays nicely with geometry, supports transparency, lossless.]
#
# 
# ###### Understanding the Script #########
# The script does a number of things here:
#
# First, it checks to make sure the user entered two inputs, that the framecount is
# not 1, and that the framecount is an integer value. If any of those fails to happen,
# it throws up warnings and stops.
#
# Second, it takes the file given and creates a for loop that GLE processes within.
# The for loop starts at i=0 and works its way up to i=(framecount - 1), spitting out
# an image for each i, and thus creating a total number of images equal to framecount.
#
# Finally, it tidies things up into a single folder.
# (This can break down one of two ways, depending on whether or not things are
# inside of a standard Chipmunk Math directory structure.)
#
# The hardest part to understand is the GLE call, so we'll break that down here:
# 	# GLE Call Specifics #
# 	 "-d" Device Output, set to PNG
# 	 "-r" Resolution (in dpi)
# 			 Note, you may want to play with this value depending on the size
# 			 you are using for your "normal" graphics. Want good resolution
# 			 but no reason to waste lots of space on crazy good resolution.
# 	 "-transparent" Output has transparent background (requires PNG)
# 	 "-output" Name for output filename
# 	 The two inputs after the "$absolutepath" are the arguments passed to GLE.
# 	 		 Usefulness of first $i is pretty clear: it's current frame value.
# 	 		 The point of the total $framecount is less obvious, though. The
# 	 		 reason that's there is so it can be used in conjunction with the
# 	 		 $i value to create a "percentage" variable ('p') in the GLE file.
# 	 		 This enables us to avoid hard-coding the number of frames into the
# 	 	 	 GLE file, and thus allows us to change the framecount by simply
# 	 		 adjusting the value given to this shell script.
#
#
# ###### Important Usage Notes #########
# NOTE: If you plan to make an animated GIF, it may be preferable to have a
# non-transparent background. GIFs don't always play nicely with transparency,
# so it might be easier to build without the '-transparency' option given in
# the call to GLE.
# 		You'll want to do some research here on best practices for making
# 		animated GIFs. Have fun! :-D
#
# NOTE: If your animation needs LaTeX, you must place that in the call to gle!
# See p. 5 of GLE Manual.
# Option flag is -tex
# 		Haven't tried to use it before, so if you wind up doing it,
# 		have an expectation of troubleshooting! :-D
# 		[At the very least, start off by running a low frame count test.]
# 			Please remove the above note once you try it.
# 				Assuming it works.
# 					Please, please let it work nicely.



### Begin Script ###

absolutepath=$1 #Absolute path to the file, given as user input.
framecount=$2 #Total number of frames for animation, given as user input.
bashscriptdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # Dir of this script

if [[ $absolutepath ]] && [[ $framecount ]]
# Above 'if' checks to make sure user gave two inputs for script's use.
	# Run script if user gave input
	then
	# Check to make sure framecount is NOT 1 (and thus cause 0 division for GLE)
				if [ $framecount -eq 1 ]
					then
					echo 
					echo "I'm sorry, Dave."
					echo "I'm afraid I can't do that."
					echo
					echo "I'm joshin', Chief, but seriously, we can't do that."
					echo "That would be a framecount of 1, which (assuming you're using the"
					echo "normal GLE animation template) would cause division by 0 and fail."
					echo 
					echo "If you're looking for an animation, you'll need more than one frame."
					echo "On the other hand, if all you want is a single image, just use GLE"
					echo "directly or go run QGLE."
					echo "If you'd like more information, open this shell script in a text editor."
					echo "You'll find documentation commented at the top."
					echo

# Framecount > 1, we're good to keep going.
else
	# Check to make sure framecount was given as a positive integer
				if ! [[ $framecount =~ [0-9]+$ ]] # That's a regular expression to check for integers.
					then
					echo
					echo "Chief, that second entry has gotta be a positive integer."
					echo "You're giving us the total number of frames, so it needs to be a whole"
					echo "number, ya know? And no writing it in English, either -- this ain't"
					echo "/War Games/. Maybe you should open this script in a text editor and read"
					echo "the commented documentation at the top of the file?"
					echo


# Framecount is an integer value, we're good to keep going.
else


	# Set up variables based on file for later use.
	filename=$(basename $absolutepath) #This is the filename, WITH extension.
	namewithoutextension="${filename%.*}" #and WITHOUT extension.
	directoryalone=$(dirname $absolutepath) #Absolute path to containing directory.


	cd $directoryalone # Moves us to working in proper directory
		# GLE can work outside of directory, but images are created in script folder


		# The real meat: our GLE call process.
		for (( i=0 ; i<framecount ; i=$i+1 )) ; do 
		  echo "$i out of $framecount"
		  gle -d png -r 300 -transparent -output ${namewithoutextension}_$i $absolutepath $i $framecount
		done
		# NOTE: If you want LaTeX in output, you need to put in the -tex flag above.
		# Frames are written inside of directory this shell script is contained in.
		# All frames have been made at this point. Just gathering and moving from here.



		if [ -d ../animations ]
# ||| Testing: put in compliance with CMath dir structure once wrapping up.
		then
		mkdir -p ../animations/$namewithoutextension
		mv ${namewithoutextension}_*.png ../animations/$namewithoutextension

			echo
			echo "Time elapsed (in seconds):   $SECONDS"
			echo
			echo "Job's done, Chief."
			echo "You can find the finished product in the 'animations' folder."
			echo

				# Check for framecount having gone lower than previous runs.

				cd ../animations/$namewithoutextension

				if [ -f ${namewithoutextension}_$framecount.png ]
					then
					echo
					echo
					echo
					echo "ATTENTION ATTENTION ATTENTION"
					echo
					echo
					echo "WARNING: You have excess animation frames!"
					echo
					echo "There are more images for this animation than the framecount you gave."
					echo "You must have previously run this animation shell script with a larger"
					echo "value for your framecount than the value you just gave."
					echo 
					echo "If you attempt to simply toss this folder of images into a video editor,"
					echo "the extra frames beyond your most recent framecount may cause trouble."
					echo
					echo "It is recommended that you go delete the excess frames."
					echo
					echo

				fi


	else
		echo
		echo "Time elapsed (in seconds):   $SECONDS"
		echo
		echo
		echo
		echo "Woah Chief!" 
		echo
		echo "Looks like you're not working in the normal directory structure"
		echo "for Chipmunk Math. This script is designed to work with that structure."
		echo "If you don't know it, you can use the script folderbuilder.sh to make it."
		echo "While we're at it, the best way to use this script is to actually just"
		echo "point the script at the absolute path to the GLE file you're animating."
		echo "That assumes you're using the normal directory structure, but it's easiest."
		echo
		echo "Next time, use the normal Chipmunk Math directory structure and have this"
		echo "script target an absolute path. Trust me, Chief, you'll love it."
		echo
		echo "To tidy things up, all the animation frame images have been moved into a"
		echo "single folder in the same directory as the GLE file you targeted."
		echo "Don't worry, we'll keep quiet about this slip-up, but try to stick to"
		echo "standard operating procedure in the future, eh, Chief?"
		echo

		mkdir -p animation-$namewithoutextension
		mv ${namewithoutextension}_*.png animation-$namewithoutextension
	fi

fi # Closing the if check that ensures framecount is a number.
fi # Closing the if check that ensures framecount > 1.


############## No User Input ###############
# If user did not give input, abort and tell them to give input.
else
	echo 
	echo "This shell script needs user input to work."
	echo "It needs two inputs, given in the format below:" 
	echo "./NameOfScript <absolute path to file> <num of frames>"
	echo "For more information, open the script with a text editor."
	echo "You'll find commented documentation at the top."
	echo

fi 