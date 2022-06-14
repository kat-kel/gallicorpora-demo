#!/bin/bash

echo -e "${inverted}Phase 3. Convert transcribed ALTO XML files to a TEI XML document.${reset}"

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"

# Check that the virtual environment is installed correctly.
ENV=alto2tei
REQS=alto2tei_requirements.txt
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
		echo -e "${inverted}Now ready to convert transcriptions to TEI.${reset}"
		fi
	else
	echo -e "${red}${inverted}Installation of pipeline is not complete.${reset}"
	echo -e "${inverted}Redirecting to the installation procedure.${reset}"
	bash install.sh
	echo -e "${inverted}Now ready to convert transcriptions to TEI.${reset}"
fi
source ".venvs/${ENV}/bin/activate"


echo -e "\n${inverted}Converting ALTO XML transcriptions into a TEI XML document.${reset}"
python 3_alto2tei/run.py

deactivate
