# Demostration of Gallic(orpor)a's pipeline (français en bas)

## Requirements
- install : python 3
- shell : bash
- operating system : Linux, Mac

## Process
0. From wherever you prefer (ex. Desktop), download this demonstration on your computer and, to be safe, create a virtual environment.

```
$ git clone https://github.com/kat-kel/gallicorpora-demo.git
$ cd gallicorpora-demo

$ python3 -m venv .env-demo
$ source .env-demo/bin/activate
```

1. In the file `arks/`, list the ARKs (Archival Resource Key) for all the Gallica sources you want to process. Separate each ARK by a line break.

in example:

```
bpt6k724151
bpt6k990549b
```

2. Download the images from Gallica while specifying the documents' ARKs, which the script will find listed in `arks/`.

`$ bash download_images.sh arks`

3. Transcribe the downloaded images while specifying the segmentation and ocr models you want to use in the folder `models/`.

The recommended model for segmentation is `lineandregionscomplexefinetune__49.mlmodel`, and the recommended model for ocr is `modelBaseline_best.mlmodel`.

`$ bash transcribe_images.sh models/lineandregionscomplexefinetune__49.mlmodel models/modelBaseline_best.mlmodel`

4. Update information about your project and authors in the file `src/config.yml`.

5. Convert the XML-ALTO files that the models produced into an XML-TEI document.

`$ bash convert_to_tei.sh`

## Results
The demo will create the folder `img/` and subfolders for each document. In the folder `img/`, a document's subfolder will store images of its pages downloaded from Gallica. The demo will also create the folder `data/` and, again, subfolders for each document. The latter subfolders will have all the XML-ALTO files for a document's pages. Outside those subfolders, directly in the folder `data/`, finished XML-TEI files for each document can be found.

## Start the demo over
You can redo part or all of the demo. After calling the command `prep_demo.sh`, you will be asked at which step you want to begin (1, 2, or 3). The script will then create the necessary conditions for you to pick up where you want to start.

`$ bash prep_demo.sh`

Step 1 -- Download images from Gallica

Step 2 -- Transcribe the images

Step 3 -- Convert the XML-ALTO files to an XML-TEI document.



# Démonstration du pipeline du projet Gallic(orpor)a (english above)

## Conditions
- installé : python 3
- terminal : bash
- système d'opération : Linux, Mac

## Utilisation
0. Depuis un endroit préféré (ex. Desktop), télécharger cette démonstration sur votre ordinateur et, pour être en toute sécurité, créer un environnement virtuel.

```
$ git clone https://github.com/kat-kel/gallicorpora-demo.git
$ cd gallicorpora-demo

$ python3 -m venv .env-demo
$ source .env-demo/bin/activate
```

1. Lister les ARKs des sources de Gallica à traiter dans le fichier `arks/`. Séparer les valeurs par une simple saute de ligne.

en exemple :

```
bpt6k724151
bpt6k990549b
```

2. Télécharger les images de Gallica en précisant les ARKs des documents, qui se trouvent dans le fichier dit ci-dessus (`arks/`).

`$ bash download_images.sh arks`

3. Transcrire les images téléchargées en précisant les modèles de segmentation et de htr à utiliser, qui se trouvent dans le dossier `models/`.

Le modèle de segmentation recommandé est `lineandregionscomplexefinetune__49.mlmodel`. Le modèle de htr recommandé est `modelBaseline_best.mlmodel`.

`$ bash transcribe_images.sh models/lineandregionscomplexefinetune__49.mlmodel models/modelBaseline_best.mlmodel`

4. Mettre à jour les informations du projet et des auteur.ice.s dans le ficher `src/config.yml`.

5. Transformer les fichiers XML-ALTO produits par les modèles en documents XML-TEI.

`$ bash convert_to_tei.sh`

## Résultats
La démo va créer un dossier `img/` dans lequel se trouveront les images de chaque document. Elle créera en suite le dossier `data/` dans lesquel les modèles de segmentation et de HTR vont créer des fichiers XML-ALTO.

## Relancer la démo
Pour refaire une partie ou la totalité de la démonstration, appeler la commande `prep_demo.sh`. Il va vous demander une réponse pour lui dira pour quel étape (1, 2, ou 3) il va recréer les conditions nécessaires.

`$ bash prep_demo.sh`

Étape 1 -- Télécharger les images de Gallica

Étape 2 -- Transcrire les images

Étape 3 -- Convertir les transcriptions d'ALTO en TEI
