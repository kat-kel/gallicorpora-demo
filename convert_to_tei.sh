#!/bin/sh

python3 -m venv venv-alto2tei
source venv-alto2tei/bin/activate

# installer des librairies python exigées
echo "En cours d'installer des librairies."
pip install --upgrade pip
pip install -r src/alto2tei_requirements.txt

python alto2tei.py

deactivate