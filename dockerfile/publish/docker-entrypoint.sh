#!/bin/bash

set -e

httpd -k start

printf "%s" "now hosting aws-hugo-example.tar.gz"

while true; do
  sleep 1
  printf "."
done
