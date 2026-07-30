oci_container_run() {
  if [[ "${CONTAINERIZATION_TOOL}" == "container" ]]; then
    echo $(container_container_run "$@")
  else
    return 1
  fi
}