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
echo -e " ._______________________________________________."
echo -e " | ${bold}Preparing the Gallic(orpor)a Project Pipeline${reset} |"
echo -e " ^-----------------------------------------------^"
echo ""

#####################################################################
# Help
#####################################################################
Help()
{
    # Display help
    echo "Install packages and download models for Gallic(orpor)a Pipeline."
    echo
    echo "Syntax: install.sh [-h|f|m]"
    echo "options:"
    echo "h    Print this Help."
    echo "f    Enter path to CSV file to download HTR and Segmentation models."
    echo "d    Do not download models. Enter path to directory containing locally-installed HTR and Segmentation models."
    echo
    echo "** Important **"
    echo "If using locally-installed models, HTR and Segmentation models must be named in accordance with the following three-part syntax:"
    echo "[1] language in a 2-letter abbreviation (e.g. 'fr')"
    echo "[2] century ('17')"
    echo "[3] function ('htr' or 'seg')"
    echo
    echo "For example, your locally-installed HTR model trained on 17th-century French texts would need to be renamed 'fr17htr.mlmodel'."
    echo "Your locally-installed Segmentation model trained on 15th-century Italian texts would need to be renamed 'it15seg.mlmodel'."
    echo
}

#####################################################################
# Download HTR and Segmentation models
#####################################################################
Download_Models()
{
    # Reset everything in the directories for ML models.
    if [ -d "models" ]
    then
        rm -r "models"
    fi
    mkdir models

    # Check that the file path given as option "-f" exists and is a CSV file.
    if ! [ -f $CSV ]
        then
            echo "Exited program."
            echo -e "${red}Error. File entered after option '-f' (${reset}${CSV}${red}) was not found.${reset}\n"
            exit
    elif ! [[ ${CSV: -4} == ".csv" ]]
        then
            echo "Exited program."
            echo -e "${red}Error. File entered after option '-f' (${reset}${CSV}${red}) does not have the '.csv' extension and might not be a CSV file.${reset}\n"
            exit
    else

    # Having validated the CSV file, inform the user that the application will now download the models.
    echo -e "\n${inverted}Downloading ML models...${reset}\n"

    # Loop through every model listed in the CSV file.
    while IFS=, read -r lang cent job url
    do
        # Check the model's function (segmentation or HTR) and display it if it is valid.
        if [[ "${job}" == "seg" ]]
            then
                echo "--------------------------------------------"
                echo "Model's function: Segmentation"
        elif [[ "${job}" ==  "htr" ]]
            then
                echo "--------------------------------------------"
                echo "Model's function: HTR"
        else
            echo "Exited program."
            echo -e "${red}Error. The column 'job' in the CSV file contains invalid data (${reset}${job}${red}). Permitted data is either 'seg' (for Segmentation) or 'htr' (for HTR / Handwritten Text Recognition).${reset}\n"
            exit
        fi

        # Display the language of the model's training data.
        echo "Training data's language (abbreviated): ${lang}"

        # Check the century of the model's training data and display it if it is two digits.
        REGEX="^[0-9]{2}$"
        if ! [[ "${cent}" =~ $REGEX ]]
        then
            echo "Exited program."
            echo -e "${red}Error. The column 'century' in the CSV file contains invalid data (${reset}${cent}${red}). Permitted data is a two-digit integer.${reset}"
            exit
        else
            echo "Training data's century: ${cent}"
        fi
        echo "--------------------------------------------"
        
        # Download the model from the URL.
        echo -e "${yellow}Requesting model from:${reset} ${url}\n"
        output="${lang}${cent}${job}.mlmodel"
        curl -o $output --location --remote-header-name --remote-name $url

        # Check that the download finished correctly.
        if ! [ -f "./${output}" ]
        then
            echo "Exited program."
            echo -e "${red}Error. Model not downloaded correctly.${reset}\n"
            exit
        else

        # Move downloaded model to directory './models/'.
        mv "./${output}" models/
        echo -e "${green}Success. Downloaded model as '${output}'.${reset}\n"
        fi

    done < <(tail -n +2 $CSV)
    fi
}

#####################################################################
# Copy Locally-installed Models
#####################################################################
No_Download()
{
    # Check that the directory entered after the option '-d' is a directory.
    if ! [ -d $NODOWNLOAD ]
        then
            echo "Exited program."
            echo -e "${red}Error. The directory entered (${NODOWNLOAD}) is not a directory.${reset}"
    else

    # If the directory is the same as './ models/', set the variable COPY to false, meaning do not copy the files inside if they are valid.
    if [[ ${NODOWNLOAD} -ef "models" ]]
        then
            COPY=false
    # If the directory is not the sams as './models/', set the variable COPY to true, meaning copy the directory's files to './models/' if they're valid.
    else
        COPY=true
        # Reset everything in the directories for ML models and virtual environments.
        if [ -d "models" ]
        then
            rm -r "models"
        fi
        mkdir models
    fi

    # Having verified the directory, check if the files inside are all Machine Learning Models.
    for FILE in $NODOWNLOAD/*; do
        if ! [[ ${FILE: -8} == ".mlmodel" ]]
            then
                echo "Exited program."
                echo "${FILE} found in ${NODOWNLOAD}"
                echo -e "${red}Error. Files found in directory ${NODOWNLOAD} do not have the '.mlmodel' extension and might not be a Machine Learning Model.${reset}\n"
                exit
        # If necessary, copy the directory's files to the folder './models/'.
        else
        # For a message to the user, get the basename of the file being checked and/or copied.
        f=`basename $FILE`
            # Check if the file should be copied.
            if [ $COPY == true ];
                then
                # Copy the validated file to './models/' and inform the user.
                cp $FILE models/
                echo "A copy of the file ${f} has been made in the directory './models/'."
            # Inform the user that the file has been validated but it will not be copied.
            else
            echo "The file ${f} is already in the directory ${NODOWNLOAD}."
            fi
        fi
    done
    fi
}

#####################################################################
# Install Virtual Environments
#####################################################################

# Set up the virtual environment using the requirements file in reqs/.
Install_Venv()
{
    # create virtual environment
    python3 -m venv ".venvs/${ENV}"
    # activate virtual environment
    source ".venvs/${ENV}/bin/activate"
    # upgrade pip and install requirements
    pip install --upgrade pip
    pip install -r "reqs/${FILE}.txt"

    # check that the all the packages and versions were installed
    REQS=$( cat reqs/${FILE} )
	PIP=$( pip freeze )
		if ! [[ $REQS == $PIP ]]
            then
            echo "Exited program."
            diff <$REQS <$PIP
            echo -e "${red}${inverted}Certain packages were not installed correctly.${reset}"
            echo -e "${red}${inverted}See above for differences between the installed packages (.venvs/${ENV}) and the requirements (reqs/${FILE}.txt).${reset}"
            exit
        else
            echo "Virtual environment ./venvs/${ENV} was successfully installed."
		fi

    deactivate
}

#####################################################################
# Main program
#####################################################################

# Loop through all the options declared when calling this script.
while [ True ]; do
# Display help text if the script was called with the option --help or -h
if [ "$1" = "--help" -o "$1" = "-h" ];
then
    Help
    shift 1
# Collect the path to where the user has registered data about the models they want to download.
elif [ "$1" = "--file" -o "$1" = "-f" ];
then
    CSV=$2
    Download_Models
    exit
# Collect the path to where the user has locally installed the models they want to use.
elif [ "$1" = "--directory" -o "$1" = "-d" ];
then
    NODOWNLOAD=$2
    No_Download
    exit
else
    break
fi
done

# Erase any preexisting environments in ./venvs
echo -e "${inverted}Installing requirements...${reset}"
if [ -d ".venvs" ]
then
    rm -r ".venvs"
fi
mkdir .venvs

# Set up virtual environment needed for downloading images.
echo -e "\n${inverted}... for downloading images from Gallica.${reset}"
ENV=download-images
FILE=download_requirements
Install_Venv

# Set up virtual environment needed for transcribing images.
echo -e "\n${inverted}... for transcribing images with ML models.${reset}"
ENV=transcribe-images
FILE=transcribe_requirements
Install_Venv

# Set up virtual environment needed for making the TEI XML document.
echo -e "\n${inverted}... for converting ALTO XML files to TEI XML.${reset}"
ENV=alto2tei
FILE=alto2tei_requirements
Install_Venv

# Console message to user that the installation process has finished.
echo -e "\n${inverted}Installation is complete.${reset}"
