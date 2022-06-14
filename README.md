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
4. Run the application.
```
bash process.sh
```