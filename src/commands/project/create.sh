local VOLUME_NAME=${args[--project_name]}
local CODE_SOURCE=${args[--source]}
local CODE_BRANCH=${args[--branch]}

local EXISTING_VOLUME_NAME=$(oci_volume_get_property ${VOLUME_NAME} "NAME")

local GIT_CLONE_ARGS=()
if [[ -n "${CODE_BRANCH}" ]]; then
  GIT_CLONE_ARGS=(--branch "${CODE_BRANCH}")
fi

if [[ -n "${EXISTING_VOLUME_NAME}" ]]; then
  echo "Project volume already exists"
  exit 1
else
  if [[ -n "${CODE_SOURCE}" ]]; then
    echo "Hydrating project volume from git source"
    oci_volume_create "${VOLUME_NAME}" --label "source=${CODE_SOURCE}"

    oci_container_run \
      --image alpine/git \
      --rm \
      --volume "${VOLUME_NAME}:/workspace" \
      -- \
     clone "${GIT_CLONE_ARGS[@]}" "${CODE_SOURCE}" /workspace/code

  else
    echo "Creating empty project"
    oci_volume_create "${VOLUME_NAME}" --label "source=NONE"
  fi

  echo "Project created"
fi
