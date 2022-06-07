#!/bin/sh

# Path to list of ARKs
arks=$1

#bash src/download_images.sh $arks

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