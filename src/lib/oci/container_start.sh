oci_container_start() {
  if [[ "${CONTAINERIZATION_TOOL}" == "container" ]]; then
    echo $(container_container_start "$@")
  else
    return 1
  fi
}