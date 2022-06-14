#!/bin/bash

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"

# 1. Download images from Gallica
# create the img/ directory, and delete preexisting one if needed
if [ -d "img" ]
	then
	rm -r img
fi
mkdir img

if [ -d "data" ]
	then
	rm -r data
fi

# Check that the virtual environment is installed correctly.
ENV=download-images
REQS=download_requirements.txt
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
		echo -e "${inverted}Now ready to download images.${reset}"
		fi
	else
	echo -e "${red}${inverted}Installation of pipeline is not complete.${reset}"
	echo -e "${inverted}Redirecting to the installation procedure.${reset}"
	bash install.sh
	echo -e "${inverted}Now ready to download images.${reset}"
fi
source ".venvs/${ENV}/bin/activate"

# prompt the user to give the location of the list of ARKs
echo -e "\n${inverted} Phase 1. Download images from Gallica.${reset}"
echo "This program will read a list of Archival Resource Keys (ARK) for the documents on
Gallica that you want to process. That list should be a simple text file with each
ARK on a new line. For example:

ark_list.txt
 _____________
|bpt6k724151
|bpt6k990549b
...

"
read -p "Enter the path to that text file: " ARKS

# gather the images from Gallica
for ARK in `cat $ARKS`; 
do 
    echo -e "${inverted}Gathering images from document with ARK $ARK.${reset}"
	echo ""
	read -p "Do you want to download all of the document? [y/n]" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		LIMIT_OPTION=""
		echo -e "You have selected to download the entire document. This will likely take several minutes."
	else
		echo ""
		read -p "How many images do you want to download? " LIMIT
		LIMIT_OPTION="-l ${LIMIT}"
	fi
		STARTTIME=$(date +%s)
    	# script from https://github.com/carolinecorbieres/Memoire_TNAH/tree/master/2_Workflow/1_ImportCatalogues
		# modified to specify new export location
		echo -e "\nDownload in progress...\nCheck the document's folder in img/ to see new downloads arrive."
		python 1_download_images/import_iiif.py ark:/12148/$ARK $LIMIT_OPTION -e img
		ENDTIME=$(date +%s)
		echo -e "\nFinished in $(($ENDTIME - $STARTTIME)) seconds."
done

deactivate