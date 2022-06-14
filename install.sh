#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to install Gallicopora pipeline's dependencies.
# -----------------------------------------------------------

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"
green="\033[42m"
yellow="\033[43m"

clear
echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${yellow}"
echo -e " ._______________________________________________."
echo -e " | ${bold}Preparing the Gallic(orpor)a Project Pipeline${reset} |"
echo -e " ^-----------------------------------------------^"
echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${yellow}"
echo ""

# Reset everything in the directories for ML models and virtual environments.
if [ -d "models" ]
then
    rm -r "models"
fi
mkdir models

echo -e "${inverted}Installing requirements...${reset}"
if [ -d ".venvs" ]
then
    rm -r ".venvs"
fi
mkdir .venvs

# Set up the virtual environment needed for downloading images, using the requirements file in reqs/.
echo -e "\n${inverted}... for downloading images from Gallica.${reset}"
python3 -m venv .venvs/download-images
source .venvs/download-images/bin/activate
pip install --upgrade pip
pip install -r reqs/download_requirements.txt
deactivate

# Set up the virtual environment needed for transcribing images, using the requirements file in reqs/.
echo -e "\n${inverted}... for transcribing images with ML models.${reset}"
python3 -m venv .venvs/transcribe-images
source .venvs/transcribe-images/bin/activate
pip install --upgrade pip
pip install -r reqs/transcribe_requirements.txt
deactivate

# Set up the virtual environment needed for making the TEI XML document, using the requirements file in reqs/.
echo -e "\n${inverted}... for converting ALTO XML files to TEI XML.${reset}"
python3 -m venv .venvs/alto2tei
source .venvs/alto2tei/bin/activate
pip install --upgrade pip
pip install -r reqs/alto2tei_requirements.txt
deactivate

# Download ML models and store (from various locations and for various centuries/languages).
# Store all the models in the directory  'models/'.
echo -e "\n${inverted}Downloading ML models...${reset}"
# Selected model for 17th-Century texts.
echo -e "\n${inverted}... for 17th-Century French HTR.${reset}"
curl -o 17htr_dentduchat.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/HTR/dentduchat.mlmodel\?raw\=true
mv 17htr_dentduchat.mlmodel models/
echo -e "\n${inverted}... for 17th-Century Segmentation.${reset}"
curl -o 17seg_appenzeller.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/Segment/appenzeller.mlmodel\?raw\=true
mv 17seg_appenzeller.mlmodel models/

# Console message to user that the installation process is finished.
echo -e "\n${inverted}Installation is complete.${reset}"