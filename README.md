# Gallic(orpor)a Pipeline

## Requirements
- python 3.9
- bash shell

## How to Use
1. Clone this repository.
```
git clone https://github.com/kat-kel/gallicorpora-demo.git
```
2. Move into this repository (go to the dev branch), and install the necessary libraries and ML models.
```
cd gallicorpora-demo
git branch -f dev origin/dev
bash install.sh
```
3. Create a list of documents on Gallica you would like to process.

The list should be a simple text file (extension .txt) and list the document's Archival Resource Key (ARK) in Gallica. Each ARK should be on a new line. In example:
```
bpt6k72609n
bpt6k111525t
```
For this demonstration, please use the list of arks downloaded with this repository, `arks`.

4. Run the application.
```
bash process.sh
```
You will be prompted to respond to two types of questions.

- Where is the list of ARKs? In response, simply enter: `arks`
- How much of each document listed in `arks` do you want to download? You can either respond `y`, meaning download all of the document, or `n` for no, do not download all of the document. The second is advisable since it takes less time and computing energy. If you want to download only a portion of a document, you will be asked to specify how many pages by entering a number. A recommended number for this demonstration is `10`.