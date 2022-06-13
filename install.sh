#!/bin/bash

bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"

echo -e "${bold} _______________________________________________ ${reset}"
echo -e "${bold}| Preparing the Gallic(orpor)a Project Pipeline |${reset}"
echo -e "${bold} ----------------------------------------------- ${reset}"
echo ""

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

echo -e "\n${inverted}... for downloading images from Gallica.${reset}"
python3 -m venv .venvs/download-images
source .venvs/download-images/bin/activate
pip install --upgrade pip
pip install -r reqs/download_requirements.txt
deactivate

echo -e "\n${inverted}... for transcribing images with ML models.${reset}"
python3 -m venv .venvs/transcribe-images
source .venvs/transcribe-images/bin/activate
pip install --upgrade pip
pip install -r reqs/transcribe_requirements.txt
deactivate

echo -e "\n${inverted}... for converting ALTO XML files to TEI XML.${reset}"
python3 -m venv .venvs/alto2tei
source .venvs/alto2tei/bin/activate
pip install --upgrade pip
pip install -r reqs/alto2tei_requirements.txt
deactivate

echo -e "\n${inverted}Downloading ML models...${reset}"
echo -e "\n${inverted}... for 17th-Century French HTR.${reset}"
curl -o 17htr_dentduchat.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/HTR/dentduchat.mlmodel\?raw\=true
mv 17htr_dentduchat.mlmodel models/
echo -e "\n${inverted}... for 17th-Century Segmentation.${reset}"
curl -o 17seg_appenzeller.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/Segment/appenzeller.mlmodel\?raw\=true
mv 17seg_appenzeller.mlmodel models/

echo -e "\n${inverted}Installation is complete.${reset}"