inspect_args

IMAGE_NAME=${args[--image_name]}
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )";)

container build -f ${SCRIPT_DIR}/lib/Dockerfile $(pwd) -t ${IMAGE_NAME}:latest

container run \
    -d \
    --rm \
    --name ${IMAGE_NAME}_LOCK_EXTRACTION \
    ${IMAGE_NAME} sleep 5

container cp ${IMAGE_NAME}_LOCK_EXTRACTION:/workspace/flake.lock $(pwd)/flake.lock
