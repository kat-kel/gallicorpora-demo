#!/bin/sh

#activate env
deactivate
#source env/bin/activate

rm -rf downloads/

while getopts a:b:l: flag
do
    case "${flag}" in
        a)ark=${OPTARG};;
				b)batch=${OPTARG};;
        l)language=${OPTARG};;
    esac
done

#If there is an ark, use it
if [[ " $@ " =~ " -a " ]];
	then
  	STARTTIME=$(date +%s)
  	echo "Downloading the images of $ark"
  	python3 1_iiif/iiif.py ark:/12148/$ark
  	echo "Completed in $(($ENDTIME - $STARTTIME)) seconds."
  else
  	echo "no single ark processing"
fi

#If there is a list of ark in a txt file, use the list
if [[ " $@ " =~ " -b " ]];
	then
    echo "Processing $batch"
  	for document in `cat $batch`;
			do
    		echo "Downloading the images of $document"
    		STARTTIME=$(date +%s)
    		python src/import_iiif.py ark:/12148/$ark -l 10;
    		ENDTIME=$(date +%s)
    		echo "Completed in $(($ENDTIME - $STARTTIME)) seconds."
			done
  else
    echo "no batch processing"
fi

# Check which language model to use for HTR
if [[ " $@ " =~ " -l " ]];
	then
  	echo "Using the HTR model for $language"
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
  else
  	echo "no model for this language"
fi
