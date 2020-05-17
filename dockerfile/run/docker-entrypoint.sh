#!/bin/bash

set -e

function main {
  local artifact_path=/tmp/artifact.tar.gz

  for _ in $(seq 1 20); do
    sleep 1
    if curl --output "${artifact_path}" "${ARTIFACT_URL}"; then
      break
    fi
  done

  tar \
    --gunzip \
    --extract \
    --verbose \
    --file "${artifact_path}" \
    --directory "${DOCROOT}"

  printf "%s\n" 'starting aws-hugo-example'

  httpd -k start

  if [[ -n "${RUN_DEBUG}" ]]; then
    /bin/bash
  else
    tail -f /var/log/httpd/access_log
  fi
}

main "$@"
