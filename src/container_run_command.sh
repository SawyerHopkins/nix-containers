inspect_args

VOLUME_NAME=${args[--project_name]}
CONTAINER_NAME=${args[--env_name]}
IMAGE_NAME=${args[--image_name]}
CODE_SOURCE=${args[--source]}
EXISTING_VOLUME_NAME=$(container volume ls | awk -v name="${VOLUME_NAME}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["NAME"]==name || $1==name {print $h["NAME"]}')
CONTAINER_STATE=$(container ls | awk -v name="${CONTAINER_NAME}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["ID"]==name || $1==name {print $h["STATE"]}')

if [ -n "${EXISTING_VOLUME_NAME}" ]; then
  echo "Creating environment for ${EXISTING_VOLUME_NAME}"
else
  echo "No project volume ${EXISTING_VOLUME_NAME}. Please run 'cdev project create' first"
fi

if [ "${CONTAINER_STATE}" = "running" ]; then
  echo "Attaching to existing development container"
elif [ -n "${CONTAINER_STATE}" ]; then
  echo "Starting development container"
  container start ${CONTAINER_NAME}
else
  echo "Creating new development container"
  container run \
    -dit \
    --name ${CONTAINER_NAME} \
    -v ${VOLUME_NAME}:/workspace/code \
    --ssh \
    --entrypoint sleep \
    ${IMAGE_NAME} infinity
fi

container exec -it ${CONTAINER_NAME} /bin/sh -c "nix develop --command bash"
