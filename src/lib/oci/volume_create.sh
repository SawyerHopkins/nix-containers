oci_volume_create() {
  if [[ "${CONTAINERIZATION_TOOL}" == "container" ]]; then
    echo $(container_volume_create "$@")
  else
    return 1
  fi
}