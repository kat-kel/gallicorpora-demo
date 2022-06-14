#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to process images with segmentation and HTR models.
# -----------------------------------------------------------

# Set variables that determine which models are for which type of document.
# The script will acccess these models from inside the directory img/<document>,
# so the path to the model needs to return to the top directory via '../../'

# 17th-century French
SEG17=../../models/17seg_appenzeller.mlmodel
# 17th-century Segmentation
HTR17=../../models/17htr_dentduchat.mlmodel

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"

echo -e "\n${inverted}Phase 2. Segment and transcribe digitized images.${reset}"

# Check that the images are downloaded.
if ! [ -d 'img' ]
then
echo -e "${red}Error. No images have been downloaded into the folder 'img/'.${reset}"
exit
fi

# Check that the virtual environment is installed correctly.
ENV=transcribe-images
REQS=transcribe_requirements.txt
if [ -d ".venvs/${ENV}" ]
	then
	source ".venvs/${ENV}/bin/activate"
	REQS=$( cat reqs/${REQS} )
	PIP=$( pip freeze )
		if ! [[ $REQS == $PIP ]]
		then
		echo -e "${red}${inverted}The pipeline's installation is not complete.${reset}"
		echo -e "${inverted}Redirecting to the installation procedure.${reset}"
		bash install.sh
		echo -e "${inverted}Now ready to transcribe images.${reset}"
		fi
	else
	echo -e "${red}${inverted}Installation of pipeline is not complete.${reset}"
	echo -e "${inverted}Redirecting to the installation procedure.${reset}"
	bash install.sh
	echo -e "${inverted}Now ready to transcribe images.${reset}"
fi
source ".venvs/${ENV}/bin/activate"

# Clear out (if necessary) and create and a new directory for the transcribed pages.
if [ -d "data" ]
	then
	rm -r data
fi
mkdir data

# Get a list of the documents whose images were downloaded.
ARKS=`ls img/`

# Check which language model to use for each document's HTR transcription.
for ARK in $ARKS
do
	echo -e "\n${inverted}Segmenting and transcribing images from document ${ARK}.${reset}"

	# Get information on the document's language and date from its IIIF manifest.
    python 2_transcribe_images/choose_model.py $ARK > model_parameters.txt

	# Set variables for this document.
	PARAMS=model_parameters.txt
	LANGUAGE=$(head -n 1 ${PARAMS})
	DATE=$(tail -n 1 ${PARAMS})

	# Run segmentation and transcription.
	### Document is from the 17th century and is in French or the language is not defined.
	echo "Applying ML models for a 17th-century document, in French or in an undefined language."
    if [[ $DATE == "16" && $LANGUAGE == "fr" || $LANGUAGE == "None" ]];
    then
	cd "img/$ARK"
    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i $SEG17 -bl ocr -m $HTR17
	cd -
	### Other conditions for other types of models...
    fi

	# Move the ALTO XML files to a subdirectory in 'data/' named after the document's ARK.
	mkdir "data/${ARK}" ; mv "img/${ARK}/"*"xml" "data/${ARK}/"
	# Delete the temporary file model_parameters.txt
	rm model_parameters.txt
done

# Deactivate the virtual environment for transcription.
deactivate
