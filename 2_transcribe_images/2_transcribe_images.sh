#!/bin/bash

# List of which models are for which type of document.
# 17th-century French
SEG17=../../models/17seg_appenzeller.mlmodel
# 17th-century Segmentation
HTR17=../../models/17htr_dentduchat.mlmodel

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"

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

# Create depository for transription data.
if [ -d "data" ]
	then
	rm -r data
fi
mkdir data

# Get list of the documents whose images were downloaded.
ARKS=`ls img/`

# Check which language model to use for each document's HTR transcription.
for ARK in $ARKS
do
	echo -e "\n${inverted}Segmenting and transcribing images from document ${ARK}.${reset}"
	# get information on the document's language and date from its IIIF manifest
    python 2_transcribe_images/choose_model.py $ARK > model_parameters.txt

	# set variables
	PARAMS=model_parameters.txt
	LANGUAGE=$(head -n 1 ${PARAMS})
	DATE=$(tail -n 1 ${PARAMS})

	# run segmentation and transcription
    if [[ $DATE == "15" ]]
    then
	cd img/$ARK
    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i $SEG17 -bl ocr -m $HTR17
    fi
	cd -
	mkdir data/$ARK ; mv img/$ARK/*.xml data/$ARK
	rm model_parameters
done

deactivate
