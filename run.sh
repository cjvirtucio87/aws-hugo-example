#!/bin/bash

set -e

. "./build.sh"

readonly RUN_CONTAINER_NAME="${NAME}"

function main {
  cleanup

  trap cleanup EXIT

  docker_create_network

  docker_build_publish "$@"

  ARTIFACT_URL="http://${NAME}-publish/aws-hugo-example.tar.gz" docker_build_run "$@"
}

main "$@"
