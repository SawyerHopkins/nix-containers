bash_is_command_available() {
  local COMMAND_NAME=${1}

  if command -v "${COMMAND_NAME}" &> /dev/null; then
    return 0
  else
    return 1
  fi
}