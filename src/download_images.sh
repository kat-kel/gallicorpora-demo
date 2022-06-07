#!/bin/sh

rm -r img
mkdir img

# gather the images
for ark in `cat $1`; 
do 
    echo "En cours de récupérer dix images du document $ark de Gallica."
    # run import_iiif.py script for each ark
    # script from https://github.com/carolinecorbieres/Memoire_TNAH/tree/master/2_Workflow/1_ImportCatalogues
    STARTTIME=$(date +%s)
    python src/import_iiif.py ark:/12148/$ark -l 10;
    ENDTIME=$(date +%s)
    echo "Terminé dans $(($ENDTIME - $STARTTIME)) seconds."
done
