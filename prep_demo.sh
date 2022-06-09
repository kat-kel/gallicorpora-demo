#!/bin/sh

echo Select which step you\'d like to start with : 1, 2, ou 3
echo 1 - download images from Gallica
echo 2 - transcribe the images
echo 3 - convert the XML-ALTO transcriptions to an XML-TEI document
read -p "Enter the step's number: " stage

if [ "$stage" = "1" ];
then
echo Delete virtual environments
rm -r venv-*
echo Delete images
rm -r img/
echo Delete the XML files
rm -r data/
fi;

if [ "$stage" = "2" ];
then 
echo Delete virtual environments
rm -r venv-*
echo Delete the XML files
rm -r data/
fi;

if [ "$stage" = "3" ];
then
echo Delete virtual environments
rm -r venv-*
echo Delete XML-TEI files
rm data/b*.xml
fi;
