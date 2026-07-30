local CONTAINER_NAME=${args[--env_name]}
local CONTAINER_SSH_PORT=$(oci_container_get_property ${CONTAINER_NAME} "SSH_PORT")

if [[ -z "${CONTAINER_SSH_PORT}" ]]; then
  echo "Could not find ssh port for container ${CONTAINER_NAME}"
  exit 1
fi

ssh_open_connection \
  --port ${CONTAINER_SSH_PORT}