oci_volume_get_property() {
  if [[ "${CONTAINERIZATION_TOOL}" == "container" ]]; then
    echo $(container_volume_get_property "$@")
  else
    return 1
  fi
}