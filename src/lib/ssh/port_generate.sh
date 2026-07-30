ssh_port_generate() {
  echo $((RANDOM % (65535 - 49152 + 1) + 49152))
}