#!/bin/sh

# filepath to the models
# segment model == lineandregionscomplexefinetune__49.mlmodel
# htr model == modelBaseline_best.mlmodel
segment_model=$1
htr_model=$2

python3 -m venv venv-transcribe
source venv-transcribe/bin/activate

# install necessary python packages
echo "En cours d'installer des librairies."
pip install --upgrade pip
pip install -r src/transcribe_requirements.txt

# segment and recognize images' text
for dos in img/*;
do
    docname=`basename "$dos"`
    echo "En cours de parcourir dans $dos"

    cd "img/$docname"

    kraken --alto --suffix ".xml" -I "*.jpg" -f image segment -i "../../$segment_model" -bl ocr -m "../../$htr_model"

    # organize all the XML-ALTO files in a folder called 'data'
    mkdir -p ../../data/$docname/; mv *xml ../../data/$docname/

    echo ""
    cd -
done

deactivate