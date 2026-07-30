local VOLUME_NAME=${args[--project_name]}
local CONTAINER_NAME=${args[--env_name]}
local IMAGE_NAME=${args[--image_name]}
local CODE_SOURCE=${args[--source]}
local DISABLE_SSH_SOCKET=${args[--no-ssh-socket]}

local EXISTING_VOLUME_NAME=$(oci_volume_get_property ${VOLUME_NAME} "NAME")
local CONTAINER_STATE=$(oci_container_get_property ${CONTAINER_NAME} "STATE")

local CONTAINER_RUN_ARGS=()
if [[ ${DISABLE_SSH_SOCKET} ]]; then
  CONTAINER_RUN_ARGS=(--no-ssh-socket)
fi

if [[ -z "${EXISTING_VOLUME_NAME}" ]]; then
  echo "No project volume ${EXISTING_VOLUME_NAME}. Please run 'cdev project create' first"
  exit 1
fi

set -ex

if [[ "${CONTAINER_STATE}" == "running" ]]; then
  echo "Attaching to existing development container"
elif [[ -n "${CONTAINER_STATE}" ]]; then
  echo "Starting development container"
  oci_container_start ${CONTAINER_NAME}
else
  echo "Creating new development container"
  oci_container_run \
    --image "${IMAGE_NAME}" \
    --name "${CONTAINER_NAME}" \
    --detach \
    --volume "${VOLUME_NAME}:/workspace/home" \
    --env "SSH_PUBKEY=$(ssh_collect_public_keys)" \
    "${CONTAINER_RUN_ARGS[@]}" \
    --
fi

# @TODO automatically open ssh connection to container