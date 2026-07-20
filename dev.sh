#!/bin/sh

CONTAINER_NAME=test123

CONTAINER_STATE=$(container list --all | awk -v name="${CONTAINER_NAME}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["ID"]==name || $1==name {print $h["STATE"]}')

if [ "${CONTAINER_STATE}" = "running" ]; then
    echo "Attaching to existing project container"
    container exec -it ${CONTAINER_NAME} bash
elif [ -n "${CONTAINER_STATE}" ]; then
    echo "Starting stopped project container"
    container start -it ${CONTAINER_NAME}
    container exec -it ${CONTAINER_NAME} bash
else
    echo "Creating container ${CONTAINER_NAME}"

    