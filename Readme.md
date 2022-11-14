# Loading BMW SORDI into NVIDIA DALI Pipeline (COCO based)
SORDI dataset has per frame annotation file in json format. Following tools create a COCO style annotation out of it. Thus the SORDI data can be easily fed into COCO style training pipelines.

Sample code to consume the COCO style SORDI with NVIDIA DALI Pipeline is given and can be used in PyTorch/Tensorflow etc.

## Table of Contents
* [Prerequisites](#prerequisites)
* [Unzipping SORDI dataset](#unzipping-sordi-dataset)
* [Building and Running the docker image](#building-and-running-the-docker-image)
* [Run 2_traverse_unzipped_SORDI.ipynb](#run-2_traverse_unzipped_sordiipynb)
* [Run 3_create_coco_annotation.ipynb](#run-3_create_coco_annotationipynb)
* [Run 4_run_DALI_coco_pipeline.ipynb](#run-4_run_dali_coco_pipelineipynb)

## Prerequisites
- NVIDIA Docker 2
- Docker CE latest stable release

## Unzipping SORDI dataset
Open a Terminal in the SORDI folder and excute the following command to unzip. 

```sh
for i in *.zip; do unzip $i; done
```

Delete zip files using the following command.

```sh
rm -rf *zip
```

This is how it should look like from a structure after unzipping.

```sh
ls -l SORDI
```
![unzip](https://user-images.githubusercontent.com/69092782/201635392-7560bf91-6637-4859-a1a9-d2cd311eaf2c.png)

## Building and Running the docker image
Base image is coming from NGC cloud (ngc.nvidia.com).

Please register if not done already (3 minutes).

Before you start, map the SORDI directory into the docker:

open ``1_run.sh`` 

Change ``/home/me/SORDI`` to the path of the extracted SORDI dataset file.

![image](https://user-images.githubusercontent.com/69092782/201643133-bd5e3410-fc6d-49f3-8861-90f1f55590c4.png)

1 - Login to NVIDIA NVCR using the following command:
```sh
docker login nvcr.io
```
2 - Login to Docker using the following command:
```sh
docker login
```
3 - Build and run the image using the following command:
```sh
source 1_run.sh
```
When done it should look like this:

![Screenshot from 2022-11-14 12-11-29](https://user-images.githubusercontent.com/69092782/201646427-1b8c68dc-17a5-4b5e-b653-094c2b1f0b03.png)

## Run 2_traverse_unzipped_SORDI.ipynb
It walks through the unzipped SORDI files. It opens a sqlite database. For each frame and annotation it creates an entry into the ``FRAMES`` table.

Inside the terminal run:
```sh
jupyter notebook
```
![image](https://user-images.githubusercontent.com/69092782/201647438-b9f87f37-7321-4da8-b222-5749daaccaf5.png)

Open the provided URL in a browser and run 2_traverse_unzipped_SORDI.ipynb

![image](https://user-images.githubusercontent.com/69092782/201648575-b5c7adc3-fd41-4938-a5e7-ecbf40eb0555.png)

You find the created sqlite database in the workspace folder. Check its entries via:
```sh
sqlite SORDI.sqlite
.tables 
select * from FRAME limit 10;
```
Feel free to create additional table entries like:
* Amount of objects in frame
* Overlap/Pixeloverlap of objects in frame
* Uncertainty estimation
* Single class or multiclass

## Run 3_create_coco_annotation.ipynb
Run the notebook to create the COCO annotation file.

The outcome is the file:

``sordi.coco``

This is a great place to filter the training dataset in a smart manner. E.g. choose multiclass training frames with a certain object overlap only. By now, this notebook does not filter at all but exports all data found in the database.


## Run 4_run_DALI_coco_pipeline.ipynb
Ready to run the pipeline? Lets go. NVIDIA DALI does image decompression and augmentations on the GPU. Since the annotation file can get larger, the initial loading and parsing takes a moment.

![image](https://user-images.githubusercontent.com/69092782/201652778-f57ade11-f28d-4534-9f59-ca1c9c65fbdc.png)

## Acknowledgments
* Adolf Hohl
