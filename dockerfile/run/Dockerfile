FROM centos:latest

ENV HUGO_VERSION 0.70.0
ENV HUGO_BIN "/tmp/hugo-${HUGO_VERSION}/bin"
ENV BUILD_DIR /tmp/aws-hugo-example
ENV DEPLOY_DIR /opt/build/aws-hugo-example

USER root

RUN yum update -y;

COPY src "${BUILD_DIR}"

RUN set -e; \
    mkdir --parents "${HUGO_BIN}"; \
    curl \
      --location \
      --output - \
      "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
      | tar \
          --extract \
          --verbose \
          --file - \
          --directory "${HUGO_BIN}"; \
    cd "${BUILD_DIR}"; \
    "${HUGO_BIN}/hugo"; \
    mv public "${DEPLOY_DIR}"; \
    rm --recursive --force "${HUGO_BIN}"; \
    cd "${DEPLOY_DIR}"; \
    rm --recursive --force "${BUILD_DIR}";
