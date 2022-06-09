#!/bin/sh

# chemin vers une liste des ARKs
segment_model=$1
htr_model=$2

# créer un environnement virtuel
python3 -m venv venv-transcribe
source venv-transcribe/bin/activate

# installer des librairies python exigées
echo "En cours d'installer des librairies."
pip install --upgrade pip
pip install -r src/transcribe_requirements.txt

# semgentation et ocrisation des images
for dos in img/*;
do
    docname=`basename "$dos"`
    echo "En cours de parcourir dans $dos"

    cd "img/$docname"

    # segmenter et ocriser toutes les images dans le dossier du document == $dos
    # segment model == lineandregionscomplexefinetune__49.mlmodel
    # htr model == modelBaseline_best.mlmodel
    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i "../../$segment_model" -bl ocr -m "../../$htr_model"

    # ranger les données XML dans un dossier data/
    mkdir -p ../../data/$docname/; mv *xml ../../data/$docname/

    echo ""
    cd -
done

deactivate