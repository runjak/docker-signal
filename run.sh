#!/bin/bash
xhost +local:$USER
xlist=$(xauth nlist $DISPLAY)
uid=$(id -u)
gid=$(id -g)
version=$(grep "version=" Dockerfile|sed -e "s/^[^\"]\+\"//"|sed -e "s/\".*//")
docker run -it \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=/.Xauthority \
  -e XLIST="\"$xlist\"" \
  -e USER_UID=$uid \
  -e USER_GID=$gid \
  -e USER=$USER \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v $XAUTHORITY:/.Xauthority \
  -v `pwd`:/home/$USER \
  --device /dev/dri \
  --cpuset-cpus 0 \
  --memory 512mb \
  --cap-add=SYS_ADMIN \
  runjak/docker-signal:$version