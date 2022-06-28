#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to process images with segmentation and HTR models.
# -----------------------------------------------------------

# Set variables that determine which models are for which type of document.
# The script will acccess these models from inside the directory img/<document>,
# so the path to the model needs to return to the top directory via '../../'

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"

# This applications virtual environment and requirements.
ENV=transcribe-images
REQS=transcribe_requirements.txt

##############################################################
# Reset Image and Data Directories
##############################################################
Setup()
{
	# Check that the images are downloaded.
	if ! [ -d 'img' ]
		then
		echo -e "${red}Error. No images have been downloaded into the folder 'img/'.${reset}"
		exit
	fi
	# Get a list of the documents whose images were downloaded.
	ARKS=`ls img/`

	# Clear out (if necessary) and create and a new directory for the transcribed pages.
	if [ -d "data" ]
		then
		rm -r data
	fi
	mkdir data
}

##############################################################
# Check and Activate the Virtual Environment
##############################################################
Activate_Venv()
{
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
}

##############################################################
# Choose Segmentation and HTR Models
##############################################################
Choose_Model()
{
	# Set variables for this document.
	PARAMS=model_parameters.txt
	LANGUAGE=$(head -n 1 ${PARAMS})
	DATE=$(tail -n 1 ${PARAMS})

	# Based on the document's parameters, the ideal segmentation model would be:
	CENT=$((DATE+1))
	idealseg="${LANGUAGE}${CENT}seg.mlmodel"
	# Based on the document's parameters, the ideal htr model would be:
	idealhtr="${LANGUAGE}${CENT}htr.mlmodel"
	echo "Ideally, this document would be segmented with model '${idealseg}', and its text would be predicted with model '${idealhtr}'."

	# If the ideal segmentation model is in the directory './models/', set it as the SEG variable.
	if [[ -f ./models/${idealseg} ]]
		then SEG=$idealseg
	else SEG=defaultseg.mlmodel
	fi

	# If the ideal HTR model is in the directory './models/', set it as the HTR variable.
	if [[ -f ./models/${idealhtr} ]]
		then HTR=$idealhtr
	else HTR=defaulthtr.mlmodel
	fi

}

##############################################################
# Main Program
##############################################################
echo -e "\n${inverted}Phase 2. Segment and transcribe digitized images.${reset}"

# Check that there are images in ./img/ and reset data (./data/) directory.
Setup

# Activate the virtual environment in ./.venvs/
echo -e "\nActivating virtual environment..."
Activate_Venv
echo -e "${yellow}Virtual environment '${ENV}' activated.${reset}"

# Transcribe images from each document's directory in './img/'
for ARK in $ARKS
do
	echo -e "\n${inverted}Segmenting and transcribing images from document ${ARK}.${reset}"

	# Get information on the document's language and date from its IIIF manifest.
    python 2_transcribe_images/doc_parameters.py $ARK > model_parameters.txt

	# Determine which language model to use for this document.
	Choose_Model

	# Apply the selected models.
	cd "img/$ARK"
	echo "The document is being segmented with '${SEG}' and the text is being predicted with '${HTR}'..."
    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i "../../models/$SEG" -bl ocr -m "../../models/$HTR"
	cd -

	# Move the ALTO XML files to a subdirectory in 'data/' named after the document's ARK.
	mkdir "data/${ARK}" ; mv "img/${ARK}/"*"xml" "data/${ARK}/"
	# Delete the temporary file model_parameters.txt
	rm model_parameters.txt
done

# Deactivate the virtual environment for downloading images.
deactivate
echo -e "\n${yellow}Virtual environment '${ENV}' deactivated.${reset}"
