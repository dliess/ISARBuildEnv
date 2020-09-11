#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/common.sh"

function print_usage
{
	echo "usage: $0 <ISAR dir>"
}

if [[ $# != 1 ]]
then
	print_usage
	exit 1
fi

ISAR_DIR=$(readlink -f $1)
echo "ISAR_DIR:$ISAR_DIR"
#TARGET_DIR=/home/$BUILD_USER/Isar
TARGET_DIR=/workspaces
echo "TARGET_DIR:$TARGET_DIR"


docker run --privileged \
       	  --mount type=bind,source=$ISAR_DIR,target=$TARGET_DIR \
		     --mount type=bind,source=$HOME/.ssh,target=/home/$BUILD_USER/.ssh \
			  --mount type=bind,source=/etc/ssl/certs,target=/etc/ssl/certs \
           --mount type=bind,source=/usr/share/ca-certificates,target=/usr/share/ca-certificates

			--workdir $TARGET_DIR \
       	-ti $DOCKER_IMAGE_TAG:latest /bin/bash
