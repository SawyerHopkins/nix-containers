oci_container_get_property() {
  if [[ "${CONTAINERIZATION_TOOL}" = "container" ]]; then
    echo $(container_container_get_property "$@")
  else
    return 1
  fi
}