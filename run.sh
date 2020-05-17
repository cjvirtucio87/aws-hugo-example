#!/bin/bash

set -e

. "./build.sh"

readonly RUN_CONTAINER_NAME="${NAME}"

function main {
  cleanup

  trap cleanup EXIT

  docker_create_network

  docker_build_run "$@"
}

main "$@"
