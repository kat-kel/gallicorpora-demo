#!/bin/sh

python3 -m venv venv-alto2tei
source venv-alto2tei/bin/activate

# install necessary python packages
echo "En cours d'installer des librairies."
pip install --upgrade pip
pip install -r src/alto2tei_requirements.txt

# convert a document's XML-ALTO files to an XML-TEI file
python alto2tei.py

deactivate