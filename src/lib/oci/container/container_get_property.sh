container_container_get_property() {
  local CONTAINER_NAME=${1}
  local CONTAINER_PROP=${2}


  if [[ "${CONTAINER_PROP}" == "STATE" ]]; then
    echo $(container inspect "${CONTAINER_NAME}" | jq '.[0].status.state')
  elif [[ "${CONTAINER_PROP}" == "SSH_PORT" ]]; then
    echo $(container inspect "${CONTAINER_NAME}" | jq '.[0].configuration.publishedPorts[] | select(.containerPort == 22) | .hostPort')
  else
    echo "Unable to extract container property ${CONTAINER_PROP}"
    exit 1
  fi
}