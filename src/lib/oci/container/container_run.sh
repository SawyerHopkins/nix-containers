container_container_run() {
  local IMAGE_NAME=""
  local SSH_SOCKET_FORWARDING=1
  local CONTAINER_RUN_ARGS=()

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --image)
        IMAGE_NAME="${2}"
        shift 2;
        ;;
      --no-ssh-socket)
        SSH_SOCKET_FORWARDING=0
        shift 1
        ;;
      --volume)
        CONTAINER_RUN_ARGS+=(-v "${2}")
        shift 2
        ;;
      --name)
        CONTAINER_RUN_ARGS+=(--name "${2}")
        shift 2
        ;;
      --rm)
        CONTAINER_RUN_ARGS+=(--rm)
        shift 1
        ;;
      --detach)
        CONTAINER_RUN_ARGS+=(--detach)
        shift 1
        ;;
      --interactive)
        CONTAINER_RUN_ARGS+=(--interactive)
        shift 1
        ;;
      --tty)
        CONTAINER_RUN_ARGS+=(--tty)
        shift 1
        ;;
      --entrypoint)
        CONTAINER_RUN_ARGS+=(--entrypoint "${2}")
        shift 2
        ;;
      --env)
        CONTAINER_RUN_ARGS+=(-e "${2}")
        shift 2
        ;;
      --)
        shift 1;
        break
        ;;
      *)
        echo "Unknown argument: $1"
        return 1
        ;;
    esac
  done

  if (( ${SSH_SOCKET_FORWARDING} )); then
    CONTAINER_RUN_ARGS+=(--ssh)
    CONTAINER_RUN_ARGS+=(--env "GIT_SSH_COMMAND=ssh -o StrictHostKeyChecking=accept-new")
  fi

  # @TODO make the port dynamic
  container run \
    "${CONTAINER_RUN_ARGS[@]}" \
    -p "$(ssh_port_generate):22" \
    "${IMAGE_NAME}" \
    "$@"
}