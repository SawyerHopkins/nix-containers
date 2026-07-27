container_container_build() {
  local IMAGE_TAG=""
  local IMAGE_CTX_DIR=$(pwd)
  local IMAGE_BUILD_ARGS=()
  local IMAGE_FILE=$(oci_get_definition_file)

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --tag)
        IMAGE_TAG=${2}
        shift 2
        ;;
      --ctx-dir)
        IMAGE_CTX_DIR=${2}
        shift 2
        ;;
      --build-arg)
        IMAGE_BUILD_ARGS+=(--build-arg "${2}")
        shift 2
        ;;
      --file)
        IMAGE_FILE=${2}
        shift 2
        ;;
      *)
        echo "Unknown argument: $1"
        return 1
        ;;
    esac
  done

  container build \
    -f "${IMAGE_FILE}" \
    "${IMAGE_BUILD_ARGS[@]}" \
    "${IMAGE_CTX_DIR}" \
    -t "${IMAGE_TAG}"
}