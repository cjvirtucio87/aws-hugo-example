#!/bin/bash

set -e

readonly NAME="aws-hugo-example"
readonly BUILD_DIR="dockerfile/build"
readonly BUILD_DOCKERFILE="${BUILD_DIR}/Dockerfile"
readonly BUILD_IMAGE_TAG="${NAME}:latest"
readonly NETWORK="${NAME}-network"

function cleanup {
  readarray -t networks <<< "$(docker network ls --filter "name=^${NAME}" --format "{{ .Name }}")"
  readarray -t containers <<< "$(docker container ps --all --filter "name=^${NAME}" --format "{{ .Names }}")"

  if [[ -n "${networks}" ]]; then
    for network in "${networks[@]}"; do
      docker network rm "${network}"
    done
  fi

  if [[ -n "${containers}" ]]; then
    for container in "${containers[@]}"; do
      docker container rm "${container}"
    done
  fi
}

function docker_build {
  local dockerfile="$1"
  local image_tag="$2"

  docker build --file "${dockerfile}" --tag "${image_tag}" .
}

function docker_create_network {
  docker network create "${NETWORK}"
}

function docker_build_run {
  docker_build "${BUILD_DOCKERFILE}" "${BUILD_IMAGE_TAG}"

  docker_run "${BUILD_IMAGE_TAG}" "$@"
}

function docker_run {
  local image_tag="$1"
  shift
  local args=("$@")

  docker run \
    --tty \
    --interactive \
    --rm \
    --name "${NAME}" \
    --network "${NETWORK}" \
    "${image_tag}" "$@"
}

function main {
  docker_build "${BUILD_DOCKERFILE}" "${BUILD_IMAGE_TAG}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
