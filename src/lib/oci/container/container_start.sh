container_container_start() {
  local CONTAINER_NAME=${1}

  container start "${CONTAINER_NAME}"
}