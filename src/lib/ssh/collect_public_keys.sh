ssh_collect_public_keys() {
  local SSH_DIR=${1:-$HOME/.ssh}
  local SSH_PUBLIC_KEYS=()

  shopt -s nullglob
  for KEY_FILE in "${SSH_DIR}"/*.pub; do
      KEY_CONTENT="$(<"${KEY_FILE}")"
      [[ "${KEY_CONTENT}" =~ [^[:space:]] ]] && SSH_PUBLIC_KEYS+=("${KEY_CONTENT}")
  done
  shopt -u nullglob

  local SSH_KEY_DATA=$(printf '%s\n' "${SSH_PUBLIC_KEYS[@]}")
  echo "${SSH_KEY_DATA}"
}