ssh_open_connection() {
  local SSH_PORT="22"
  local SSH_USER="root"
  local SSH_HOST="localhost"

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --port)
        SSH_PORT=${2}
        shift 2
        ;;
      --user)
        SSH_USER=${2}
        shift 2
        ;;
      --host)
        SSH_HOST+=(--build-arg "${2}")
        shift 2
        ;;
      *)
        echo "Unknown argument: $1"
        return 1
        ;;
    esac
  done

  # @TODO Once host ssh key is stable
  # we don't need to ignore this anymore
  ssh \
    -p "${SSH_PORT}" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "${SSH_USER}@${SSH_HOST}"
}