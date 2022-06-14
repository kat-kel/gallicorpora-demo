#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to run 3 phases of Gallicorpora pipeline.
# -----------------------------------------------------------

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"
green="\033[42m"
yellow="\033[43m"

clear
echo -e " ._______________________________________________."
echo -e " | ${bold}Preparing the Gallic(orpor)a Project Pipeline${reset} |"
echo -e " ^-----------------------------------------------^"
echo ""

# 1. Download images from Gallica
bash 1_download_images/1_download_images.sh

# 2. Transcribe images
bash 2_transcribe_images/2_transcribe_images.sh

# 3. Convert to TEI
bash 3_alto2tei/3_alto2tei.sh
