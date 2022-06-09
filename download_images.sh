#!/bin/sh

python3 -m venv venv-download_images

source venv-download_images/bin/activate
pip install --upgrade pip
pip install -r src/download_requirements.txt

mkdir img

# gather the images
for ark in `cat $1`; 
do 
    echo "En cours de récupérer dix images du document $ark."
    # run import_iiif.py script for each ark
    # script from https://github.com/carolinecorbieres/Memoire_TNAH/tree/master/2_Workflow/1_ImportCatalogues
    STARTTIME=$(date +%s)
    python src/import_iiif.py ark:/12148/$ark -l 10;
    ENDTIME=$(date +%s)
    echo "Terminé dans $(($ENDTIME - $STARTTIME)) seconds."
done

deactivate