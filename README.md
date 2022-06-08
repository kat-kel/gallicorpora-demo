# Démonstration du pipeline du projet Gallic(orpor)a

## Conditions
- python
- bash shell

## Utilisation
1. Lister les ARK des sources de Gallica à traiter dans le fichier `/arks`. Séparer les valeurs par une saute de ligne.

2. Lancer le script en précisant la liste des ARKs (`arks`).

`$ bash demo.sh arks`

## Résultats
La démo va créer un dossier `img/` dans lequel se trouveront les images de chaque document. Elle créera en suite le dossier `data/` dans lesquel les modèles de segmentation et de HTR vont créer des fichiers XML-ALTO.
