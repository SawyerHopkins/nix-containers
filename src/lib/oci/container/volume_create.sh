container_volume_create() {
  local PROJECT_NAME=${1}
  local PROJECT_LABELS=(--label "project=${PROJECT_NAME}")
  shift 1

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --label)
        PROJECT_LABELS+=(--label "${2}")
        shift 2
        ;;
      *)
        echo "Unknown argument: $1"
        return 1
        ;;
    esac
  done

  container volume create \
    "${PROJECT_LABELS[@]}" \
    "${PROJECT_NAME}"
}