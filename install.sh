#!/bin/bash

#create env
python3 -m venv env
#activate env
source env/bin/activate
#install packages
pip install -r requirements.txt
#create directory if does not exist
mkdir -p models
#get HTR model
curl -o dentduchat.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/HTR/dentduchat.mlmodel\?raw\=true
#move model to directory
mv dentduchat.mlmodel models/
#get HTR model
curl -o appenzeller.mlmodel --location --remote-header-name --remote-name https://github.com/Heresta/OCR17plus/blob/main/Model/Segment/appenzeller.mlmodel\?raw\=true
#move model to directory
mv appenzeller.mlmodel models/
