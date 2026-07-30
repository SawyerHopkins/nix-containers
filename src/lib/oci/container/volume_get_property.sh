container_volume_get_property() {
  local VOLUME_NAME=${1}
  local VOLUME_PROP=${2}

  if [[ "${VOLUME_PROP}" == "NAME" ]]; then
    echo $(container volume inspect "${VOLUME_NAME}" | jq '.[0].configuration.name')
  else
    echo "Unable to extract volume property ${VOLUME_PROP}"
    exit 1
  fi
}