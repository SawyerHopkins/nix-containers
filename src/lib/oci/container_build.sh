oci_container_build() {
  if [[ "${CONTAINERIZATION_TOOL}" == "container" ]]; then
    echo $(container_container_build "$@")
  else
    return 1
  fi
}