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
4. Run the script `process.sh` with its required parameter `-f`.

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

## How the Model Is Chosen

1. Figure out what would be the ideal model.

    IIIf manifests usually have data fields that label the document's language(s) and its date(s) of publication. This data is stored in a JSON format.
    
    ```json
    
    {
        "metadata":
            {
            "label":  "Language",
            "value":  "Italian"
            },
            {
            "label":  "Date",
            "value":  "1425-1450"
            }
    }
    ```
    The python script `scripts/doc_parameters.py` queries the document's IIIF manifest and accesses the first value of the labels "Language" and "Date." To clean the language, the script parses the first two letters and casts them in lower case. It also parses the first two numbers from the date. These two values are then sent to a temporary file: `model_parameters.txt`.

    ```  
    it
    14
    ```
    
    The shell script `scripts/2_transcribe_images.sh` then parses this temporary file and uses its data to construct the name of the ideal models for the document. First, the script checks that the language abbreviation parsed from the IIIF manifest is indeed two lower-case letters. It also checks that date abbreviation is a two-digit integer, and then it increases the number by 1. This summation represents the century in which the document was published.

    With these cleaned data, the ideal models for the document are then recognized as the concatenation of the language abbreviation, century, and the model's function ("seg" or "htr"). The example IIIF manfiest metadata above, for instance, would be parsed by the python and shell scripts and the document's ideal models would be `it15seg.mlmodel` for segmentation and `it15htr.mlmodel` for text recognition.

2. Figure out if that ideal model was installed.

    During the installation process, either models were downloaded and named according to the syntax described above (language+century+function) or they were already locally installed on the computer. The installation process verifies that the locally installed models adhere to the required syntax.
    
    In either case, default models are also downloaded during the installation. URLs to download a default segmentation and a default HTR model are assigned to variables `DEFAULTSEG` and `DEFAULTHTR`.

    
    ```bash
    # URL for a default segmentation model
    DEFAULTSEG=https://github.com/Heresta/OCR17plus/raw/main/Model/Segment/appenzeller.mlmodel

    # URL for a default htr model
    DEFAULTHTR=https://github.com/Heresta/OCR17plus/raw/main/Model/HTR/dentduchat.mlmodel
    ```

    Having determined what would be the ideal models to apply to the document, the shell script `2_transcribe_images.sh` checks if the directory `./models/` contains them. Because a strict naming syntax is rigorously applied, if a model trained on data from the same century and language as the document was indeed installed, it will have the same name as what the script determined would be the "ideal model." The shell script applies that ideal model if it finds it in `./models/`. However, if the shell script does not find what it believes is the ideal model, the script applies the default models `defaultseg.mlmodel` and `defaulthtr.mlmodel` in `./models/`.
