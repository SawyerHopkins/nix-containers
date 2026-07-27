local IMAGE_NAME=${args[--image_name]}
local CDEV_IMAGE_TAG=$(oci_get_cdev_image_tag)
local CDEV_CONTAINER_FILE=$(oci_get_cdev_definition_file)

oci_container_build \
  --tag "${CDEV_IMAGE_TAG}" \
  --file "${CDEV_CONTAINER_FILE}" \
  --ctx-dir "$(dirname "${CDEV_CONTAINER_FILE}")"

oci_container_build \
  --tag "${IMAGE_NAME}:latest" \
  --build-arg "BASE_IMAGE=${CDEV_IMAGE_TAG}"
