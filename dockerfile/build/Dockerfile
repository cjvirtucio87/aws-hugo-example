FROM centos:latest

ENV HUGO_VERSION 0.70.0
ENV HUGO_BIN "/tmp/hugo-${HUGO_VERSION}/bin"
ENV BUILD_DIR /tmp/aws-hugo-example

USER root

RUN set -e; \
    yum update -y;

COPY src "${BUILD_DIR}"
