#!/bin/sh
xhost local:root
if [ ! -d $HOME/wine-devel ]; then
    echo "Copying Wine development files to $HOME/wine-devel on the host..."
    tmp_id=$(docker create wine-devel)
    docker cp $tmp_id:/root $HOME/wine-devel
    docker rm -v $tmp_id
fi
echo "/root in the container corresponds to $HOME/wine-devel on the host"
docker run -ti --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/wine-devel:/root \
    wine-devel
