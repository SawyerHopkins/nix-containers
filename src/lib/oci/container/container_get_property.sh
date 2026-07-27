container_container_get_property() {
  local CONTAINER_NAME=${1}
  local CONTAINER_PROP=${2}

  echo $(container ls | awk -v name="${CONTAINER_NAME}" -v prop="${CONTAINER_PROP}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["ID"]==name || $1==name {print $h[prop]}')
}