# Gallic(orpor)a Pipeline

## Requirements
- python 3.9
- bash shell

## How to Use
1. Clone this repository.
```
git clone https://github.com/kat-kel/gallicorpora-demo.git
```
2. Move into this repository and install the necessary libraries and ML models.
```
cd gallicorpora-demo
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

---
### During the process, in phase 1 (Download images from Gallica), you will be asked to respond to two types of questions.

1. Where can the program find the list of ARKs you'd like it to read?
```
Enter the path to the text file: 
```
For this demonstration, simply enter: "arks"

2. How much of each document listed in `arks` do you want to download and process?
```
Do you want to download all of the document? [y/n]
```
Because it takes less time and computing power, it is recommended for this demonstration that you reply "n". This answer will prompt a follow-up question.
```
How many images do you want to download?
```
You should reply with a number, such as "10".
