# Loading BMW SORDI into NVIDIA DALI Pipeline (COCO based)

SORDI dataset has per frame annotation file in json format. Following tools create a COCO style annotation out of it. Thus the SORDI data can be easily fed into COCO style training pipelines.

Sample code to consume the COCO style SORDI with NVIDIA DALI Pipeline is given and can be used in PyTorch/Tensorflow etc.

# How does it work?

Build the container (`1_run.sh`), unzip all SORDI zips (`0_unpack_all.txt`), run the container, make inventory and dump all annotations in a sqlite database (2_traverse_unzipped_SORDI.py), create the COCO annotation file from the database (3_create_coco_annotation.ipynb), consume the annotation (4_run_DALI_coco_pipeline.py)

## 0_unpack_all.txt
unpack all zips. This is how it should look like from a structure after unzipping. 

``
(base) me@local:~$ ls -l SORDI
total 64
-rw-rw-r-- 1 me me 18035 Sep 30 15:53  config.json
drwxrwxr-x 4 me me  4096 Sep  2 17:10  SORDI_2022_h4001_bicycle
drwxrwxr-x 4 me me  4096 Sep  2 17:10  SORDI_2022_h4002_cabinet
drwxrwxr-x 4 me me  4096 Sep  2 17:11  SORDI_2022_h4004_dolly
drwxrwxr-x 4 me me  4096 Sep  2 17:11  SORDI_2022_h4007_forklift
drwxrwxr-x 4 me me  4096 Sep  2 17:12  SORDI_2022_h4008_jack
drwxrwxr-x 4 me me  4096 Sep  2 17:13  SORDI_2022_h4012_locker
drwxrwxr-x 4 me me  4096 Sep  2 17:13  SORDI_2022_h4013_pallet
drwxrwxr-x 4 me me  4096 Okt  4 15:09  SORDI_2022_h4017_STR
drwxrwxr-x 4 me me  4096 Sep  2 17:14  SORDI_2022_h4020_warehouse
drwxrwxr-x 4 me me  4096 Sep  2 17:13 'SORDI_2022_h4023_industrial rooms'
drwxrwxr-x 4 me me  4096 Sep  2 17:13 'SORDI_2022_h4024_regensburg plant 360p'
``

## 1_run.sh
Builds the docker image. Base image is coming from NGC cloud (ngc.nvidia.com). Register in 3 minutes if not done already.
Before you start, map the SORDI directory into the docker before using "-v outside_container:inside_container option".

`The notebooks in the docker container assume SORDI mapped to the root of the in-container directory tree`

Then hit it and start jupyter notebook inside the container. See below:

``
source 1_run.sh #outside container
...
root@d6f67eae9f67:/workspace# jupyter notebook   #inside the container
``

## 2_traverse_unzipped_SORDI.py
Run it completly. It walks through the unzipped SORDI files. It opens a sqlite database. For each frame and annotation it creates an entry into the FRAMES table. 

You find the created sqlite database in the workspace folder. Check its entries via:

``
sqlite SORDI.sqlite
.tables
select * from FRAME limit 10;
``

This takes ~2 min to run. Feel free to create additional table entries like:
* Amount of objects in frame
* Overlap/Pixeloverlap of objects in frame
* Uncertainty estimation
* Single class or multiclass


## 3_create_coco_annotation.ipynb

Next run the notebook to create the COCO annotation file. This one runs a bit longer. The outcome is the file:

`
sordi.coco
`

This is a great place to filter the training dataset in a smart manner. E.g. choose multiclass training frames with a certain object overlap only.
By now, this notebook does not filter at all but exports all data found in the database.

## 4_run_DALI_coco_pipeline.py

Ready to run the pipeline? Lets go. NVIDIA DALI does image decompression and augmentations on the GPU. Since the annotation file can get larger, the initial loading and parsing takes a moment.