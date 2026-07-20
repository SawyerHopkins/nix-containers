echo "# This file is located at 'src/init_command.sh'."
echo "# It contains the implementation for the 'cdev init' command."
echo "# The code you write here will be wrapped by a function named 'cdev_init_command()'."
echo "# Feel free to edit this file; your changes will persist when regenerating."
inspect_args

VOLUME_NAME=${args[project_name]}
CODE_SOURCE=${args[--source]}
EXISTING_VOLUME_NAME=$(container volume ls | awk -v name="${VOLUME_NAME}" 'NR==1{for(i=1;i<=NF;i++)h[$i]=i; next} $h["NAME"]==name || $1==name {print $h["NAME"]}')

if [ -n "${EXISTING_VOLUME_NAME}" ]; then
  echo "Project already exists"
  exit 1
else
  if [ -n "${CODE_SOURCE}" ]; then
    echo "Hydrating project code from source"
    container run \
      --rm \
      --ssh \
      --env "GIT_SSH_COMMAND=ssh -o StrictHostKeyChecking=accept-new" \
      -v ${VOLUME_NAME}:/workspace \
      alpine/git \
      clone ${CODE_SOURCE} /workspace/code
  else
    echo "Creating empty project"
    container volume create \
      --label project=${VOLUME_NAME} \
      --label source=${CODE_SOURCE} \
      ${VOLUME_NAME}
  fi

  echo "Project created"
fi