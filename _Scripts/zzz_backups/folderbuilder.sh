#!/bin/bash

#### NOTE! ####
# This script is predicated (as noted below) on being run from one directory
# under the top level of your course directory. If it's being run from
# somewhere else, please modify the below or be unhappy.

foldername=$1

if [ $foldername ] #This just checks for existence of user input
	# Run script if user gave input
	then

	cd .. # NOTE: This command assumes you are located just below top level of course.

	topdir=$(pwd)

	echo
	echo "About to create Chipmunk Math directory structure."
	echo "Folder: $(tput smso)$1$(tput rmso)" # 'tput' is used to do text formatting
	echo "Full path: $topdir/$1"
	echo -n "Please confirm you want to do this (y/n):" # -n prevents new line
	printf "%4s"  # A bit silly, just there for typesetting in a space after question.

	read answer

	echo

	if [ $answer = y ] || [ $answer = Y ] || [ $answer = yes ] || [ $answer = Yes ] || [ $answer = YES ]
		# The '||' above has the function of an OR, allowing all of those as answers.
		then
		echo "As you wish."

				mkdir -p $topdir/$1/0-planning
					# Makes a place for lesson plans, etc to go into.
		
		declare -a normallessons=("1-basic" "2-advanced" "3-problems" "4-review")
			#array of 

		for i in "${normallessons[@]}"
			do
				echo "$i --> images, gle, slide_imgs_for_vid, animations, geogebra"
				mkdir -p $topdir/$1/$i/images
				mkdir -p $topdir/$1/$i/gle
				mkdir -p $topdir/$1/$i/slide_imgs_for_vid
				mkdir -p $topdir/$1/$i/animations
				mkdir -p $topdir/$1/$i/geogebra	

				# At this point, the general file structure is complete
				# What follows below is for optional extra files.

			done



		echo
		echo -n "Do you need extra video types beyond the normal set (y/n)?"
		printf "%4s"  # Just for typesetting, see above.

		read extraanswer

		echo

		if [ $extraanswer = y ] || [ $extraanswer = Y ] || [ $extraanswer = yes ] || [ $extraanswer = Yes ] || [ $extraanswer = YES ]
			then
				extracorrect=no # Sets up variable for coming while loop

				### Begin: Getting extra names and verifying ###
				until [ $extracorrect = y ] || [ $extracorrect = Y ] || [ $extracorrect = yes ] || [ $extracorrect = Yes ] || [ $extracorrect = YES ]
					do
					echo "Please enter the name for each extra video type."
					echo "Put spaces between names, names may not contain a space."
					echo "The folders will be named as '#-YourNameHere'"
					echo "Or, if you've changed your mind about extra lessons, type 'exit'."
					echo
					echo -n "Extra Folder Names:"
					printf "%4s"  # Just for typesetting, see above.

					read -a extranames

							### Escape clause if they didn't mean to put in extra folders.
							if [ $extranames = exit ]
								then 
								echo "Get me outta here!"
								echo "[All of the normal lesson folders have been created.]"
								echo
								exit 0
							fi

					echo
					echo "Your extra lesson folders will be named:"
					n=4 # Used for putting proper count to extra video
						for j in "${extranames[@]}"
								do
									let n=$n+1
									echo "$n-$j"
							done
					echo

					echo -n "Is that correct (y/n)?"
					printf "%4s"  # Just for typesetting, see above.

					read extracorrect
					echo
				done
				### End: Getting extra names and verifying ###



		### Begin: Using verified names to create extra video folders ###
						n=4 # Used for putting proper count to extra video
						for j in "${extranames[@]}"
								do
									let n=$n+1
									echo "$n-$j --> images, gle, slide_imgs_for_vid, animations, geogebra"
									mkdir -p $topdir/$1/$n-$j/images
									mkdir -p $topdir/$1/$n-$j/gle
									mkdir -p $topdir/$1/$n-$j/slide_imgs_for_vid
									mkdir -p $topdir/$1/$n-$j/animations
									mkdir -p $topdir/$1/$n-$j/geogebra	
							done
						echo

		### End: Using verfied names to create extra video folders ###


		fi



echo "Job's done. See you, space cowboy."
echo "Oh, and hey, try to remember to delete any unnecessary directories."
echo





### Entered in wrong folder name ###
	else
		echo "Changed your mind, eh? Alright, see you round."
		echo
	fi



############## No User Input ###############
# If user did not give input, abort and tell them to give input.
else
	echo 
	echo "This shell script needs user input to work."
	echo "Please try again in this format: ./NameOfScript FolderNameGoesHere"
	echo
fi