FROM nvcr.io/nvidia/pytorch:22.09-py3

RUN pip install --upgrade pip
RUN pip install --upgrade numpy

RUN pip install jupyter
RUN pip install matplotlib
RUN pip install sklearn
RUN pip install pillow
RUN pip install Pillow==6.1
RUN pip install torchsummary

RUN pip install scikit-learn
RUN pip install scikit-image
RUN pip install tflearn
RUN pip install h5py
RUN pip install pandas
RUN pip install tensorboardX

#RUN pip install optuna 
#RUN pip install psycopg2-binary

RUN apt-get update
#RUN apt-get install libopencv-dev
#RUN pip install opencv-python

# Add a notebook profile for execution in unconstrained mode.
RUN mkdir -p -m 700 /root/.jupyter/
COPY jupyter_notebook_config.py /root/.jupyter/

