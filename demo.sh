#!/bin/sh

# chemin vers une liste des ARKs
arks=$1

# créer un environnement virtuel
python3 -m venv venv-demo
source venv-demo/bin/activate

# installer des librairies python exigées
echo "En cours d'installer des librairies."
pip install --upgrade pip
pip install kraken==3.0.13
pip install protobuf==3.19.0

# télécharger en locale les pages de chaque document dont l'ARK se trouve dans la liste './arks'
bash src/download_images.sh $arks

# semgentation et ocrisation des images
for dos in img/*;
do
    docname=`basename "$dos"`
    echo "En cours de parcourir dans $dos"

    cd "./img/$docname"

    # segmenter et ocriser toutes les images dans le dossier du document == $dos
    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i ../../models/lineandregionscomplexefinetune__49.mlmodel -bl ocr -m ../../models/modelBaseline_best.mlmodel
    # ranger les données XML dans un dossier data/
    mkdir -p ../../data/$docname/; mv *xml ../../data/$docname/

    echo ""
    cd -
done