# Démonstration du pipeline du projet Gallic(orpor)a

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
