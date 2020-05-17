#!/bin/bash

set -e

readonly NAME="aws-hugo-example"
readonly BUILD_DIR="dockerfile/build"
readonly BUILD_DOCKERFILE="${BUILD_DIR}/Dockerfile"
readonly BUILD_IMAGE_TAG="${NAME}-build:latest"
readonly PUBLISH_DIR="dockerfile/publish"
readonly PUBLISH_DOCKERFILE="${PUBLISH_DIR}/Dockerfile"
readonly PUBLISH_IMAGE_TAG="${NAME}-publish:latest"
readonly NETWORK="${NAME}-network"
readonly RUN_DIR="dockerfile/run"
readonly RUN_DOCKERFILE="${RUN_DIR}/Dockerfile"
readonly RUN_IMAGE_TAG="${NAME}:latest"

function cleanup {
  readarray -t networks <<< "$(docker network ls --filter "name=^${NAME}" --format "{{ .Name }}")"
  readarray -t containers <<< "$(docker container ps --all --filter "name=^${NAME}" --format "{{ .Names }}")"

  if [[ -n "${containers}" ]]; then
    for container in "${containers[@]}"; do
      docker container rm --force "${container}"
    done
  fi

  if [[ -n "${networks}" ]]; then
    for network in "${networks[@]}"; do
      docker network rm "${network}"
    done
  fi
}

function docker_build {
  local dockerfile="$1"
  local image_tag="$2"

  local args=(
    --file "${dockerfile}"
    --tag "${image_tag}"
  )

  if [[ -v REBUILD ]]; then
    args+=(--no-cache)
  fi

  docker build "${args[@]}" .
}

function docker_build_run {
  docker_build "${RUN_DOCKERFILE}" "${RUN_IMAGE_TAG}"

  docker_run "${RUN_IMAGE_TAG}" "${NAME}" "$@"
}

function docker_create_network {
  docker network create "${NETWORK}"
}

function docker_build_publish {
  docker_build "${PUBLISH_DOCKERFILE}" "${PUBLISH_IMAGE_TAG}"

  docker_publish "${PUBLISH_IMAGE_TAG}" "${NAME}-publish"
}

function docker_publish {
  local image_tag="$1"
  shift
  local container_name="$1"
  shift
  local args=("$@")

  local run_args=(
    --detach
    --tty
    --interactive
    --name "${container_name}"
    --network "${NETWORK}"
  )

  docker run \
    "${run_args[@]}" \
    "${image_tag}" "${args[@]}"
}

function docker_run {
  local image_tag="$1"
  shift
  local container_name="$1"
  shift
  local args=("$@")

  local run_args=(
    --rm
    --tty
    --interactive
    --name "${container_name}"
    --network "${NETWORK}"
    --env "ARTIFACT_URL=${ARTIFACT_URL}"
    --env "RUN_DEBUG=${RUN_DEBUG}"
  )

  if [[ -n "${EXPOSE_PORT}" ]]; then
    run_args+=(--publish "${EXPOSE_PORT}:80")
  fi

  docker run \
    "${run_args[@]}" \
    "${image_tag}" "${args[@]}"
}

function main {
  docker_build "${BUILD_DOCKERFILE}" "${BUILD_IMAGE_TAG}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
