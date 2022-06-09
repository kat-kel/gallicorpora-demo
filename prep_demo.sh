#!/bin/sh

echo Sélectionner auquel stade à commencer : 1, 2, ou 3
echo 1 - télécharger les images de Gallica
echo 2 - transcrire les images avec les modèles
echo 3 - transformer les transcriptions en TEI
read -p "Entrer le nombre du stade : " stage

if [ "$stage" = "1" ];
then
echo Supprimer les environnements
rm -r venv-*
echo Supprimer le dossier des images
rm -r img/
echo Supprimer le dossier des XML
rm -r data/
fi;

if [ "$stage" = "2" ];
then 
echo Supprimer les environnements
rm -r venv-*
echo Supprimer le dossier des XML
rm -r data/
fi;

if [ "$stage" = "3" ];
then
echo Supprimer les environnements
rm -r venv-*
echo Supprimer les fichiers XML-TEI
rm data/b*.xml
fi;
