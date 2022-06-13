#!/bin/bash

bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"

echo -e "${bold} _______________________________________________ ${reset}"
echo -e "${bold}| Launching the Gallic(orpor)a Project Pipeline |${reset}"
echo -e "${bold} ----------------------------------------------- ${reset}"
echo ""

# 1. Download images from Gallica
bash 1_download_images/1_download_images.sh

# 2. Transcribe images
bash 2_transcribe_images/2_transcribe_images.sh

# 3. Convert to TEI
#bash alto2tei/3_alto2tei.sh
