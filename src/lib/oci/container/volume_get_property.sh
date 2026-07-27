container_volume_get_property() {
  local VOLUME_NAME=${1}
  local VOLUME_PROP=${2}

  echo $(container volume ls | awk -v name="${VOLUME_NAME}" -v prop="${VOLUME_PROP}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["NAME"]==name || $1==name {print $h[prop]}')
}