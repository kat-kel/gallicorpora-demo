#!/bin/sh

# Path to list of ARKs
arks=$1

# créer un environnement virtuel
python3 -m venv venv-demo

# installer des librairies python exigées
echo "En cours d'installer des librairies."
pip install kraken
kraken get 10.5281/zenodo.5617783

# télécharger en locale les pages de chaque document dont l'ARK se trouve dans la liste './arks'
bash src/download_images.sh $arks

# pre-processing des images
for i in img/*;
do
    doc=`basename "$i"`
    echo "En cours de parcourir dans $i"

    # binarize images
    kraken -I "$i/*" -o .png binarize
    mkdir -p ./data/$doc/bin; mv $i/*png ./data/$doc/bin/

    # segment images
    kraken -I "./data/$doc/bin/*.png" -o .json segment
    mkdir -p ./data/$doc/seg; mv ./data/$doc/bin/*json ./data/$doc/seg/
    echo ""
done