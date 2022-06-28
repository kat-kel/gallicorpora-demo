# Gallic(orpor)a Pipeline

## Requirements
- python 3.9
- bash shell
---
---
## How to Use
---
### Download the Application
1. Clone this repository.
```
$ git clone https://github.com/kat-kel/gallicorpora-demo.git
```
2. Move into this repository (go to the dev branch).
```
$ cd gallicorpora-demo
$ git branch -f dev origin/dev
```
---
### Set up the Application
3. Install models and dependencies.
- If you want to see the two ways of preparing Machine Learning models for the application, call the installation procedure with the option `-h` or `--help` for help.
    ```
    $ bash install.sh -h
    ```
- **OPTION 1.** If you want to download Machine Learning models from an online repository (GitHub, Zenodo, HuggingFace, etc.), follow these two steps:

    1. In the file `model_list.csv`, write the URL and some information about what the model does. That informaiton includes the training data's language, the training data's century, and model's task: segmentation (seg) or handwritten text recognition/ocr (htr). The URL needs to be the exact URL that triggers the model's download (not simply the page on which that URL can be accessed).

        |language|century|job|url|
        |--------|-------|---|---|
        |fr|17|seg|https://github.com/...mlmodel|
        |fr|17|htr|https://github.com/...mlmodel|

        *When you download this prototype,* `model_list.csv` *already has models listed for 17th-century French texts that you can use.*

    2. With the `model_list.csv` prepared, launch the installation with the option `-f` and the path to the CSV file.
        ```
        $ bash install.sh -f model_list.csv
        ```

- **OPTION 2.** If you have Machine Learning models installed on your local machine, follow these two steps:

    1. Copy and/or rename the models according to the following syntax:

        |language|century|job|file extension|
        |--|--|--|--|
        |`fr`|`17`|`htr`|`.mlmodel`|
        |lower-case letters|digits|"seg" or "htr"|.mlmodel

        example file name: `fr17htr.mlmodel`

    2. Launch the installation with the option `-d` and the path to the directory containing the properly (re)named models.

        ```
        $ bash install.sh -d <DIRECTORY>
        ```

>Note: The prototype currently recognizes which model to apply to a document by parsing the digitized document's IIIF manifest and extracting the first two letters of the text's primary language, as it is registered in the manifest. This means that the prototype does not distinguish between different types of French, such as *moyen français* (frm) and *français moderne* (fra). Without standardization in how the IIIF manifest records a document's language, the prototype parses just the language's first two letters. If you are using your own models, (re)name a copy of the model where the first two characters are the first two letters of the language of the document's training data as that language would likely be written in a IIIF manifest.

---
### Run the Application
4. Run the script `process.sh` with its required parameter.

- In order to know which documents to download and transcribe, the application needs to read a text file. This file should have all the Archival Resource Keys (ARK) of each document recorded, each on a new line. The text file will resemble this:

    ```
    bpt6k72609n
    bpt6k111525t
    ```
    After the option `-f`, give the relative path to that file.
    ```
    $ bash process.sh -f <FILE>
    ```
    *When you download this prototype, the text file* `arks.txt` *already has Archival Resource Keys that you can use. Enter into the command line* `bash process.sh -f arks.txt`.
- If you do not want to download all of a document, the option `-l` allows you to limit the number of pages.
    ```
    $ bash process.sh -f <FILE> -l <LIMIT>
    ```