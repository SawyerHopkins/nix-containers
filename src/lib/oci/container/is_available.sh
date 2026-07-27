container_is_available () {
  if bash_is_command_available "container"; then
    return 0
  else
    return 1
  fi
}