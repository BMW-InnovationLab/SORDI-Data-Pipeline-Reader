docker build . -t sordi/hackathon:1.0

docker run --gpus '"device=0"' -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --shm-size=1g --ulimit memlock=-1 --ipc=host -v /tmp/nvidia-mps:/tmp/nvidia-mps --env JUPYTER_PORT='18888' -p 18888:18888 -p 6006:6006 -v /tmp:/tmp -v /home/me/SORDI:/SORDI -v ${PWD}:/workspace sordi/hackathon:1.0

