FROM centos:latest

ENV HUGO_VERSION 0.70.0
ENV HUGO_BIN "/tmp/hugo-${HUGO_VERSION}/bin"
ENV BUILD_DIR /tmp/aws-hugo-example
ENV DOCROOT /var/www/html

USER root

COPY src "${BUILD_DIR}"

RUN set -e; \
    yum install httpd -y; \
    yum clean all; \
    mkdir --parents "${HUGO_BIN}"; \
    curl \
      --location \
      --output - \
      "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" \
      | tar \
          --gunzip \
          --extract \
          --verbose \
          --file - \
          --directory "${HUGO_BIN}"; \
    cd "${BUILD_DIR}"; \
    "${HUGO_BIN}/hugo"; \
    cd public; \
    tar \
      --gunzip \
      --create \
      --verbose \
      --file "${DOCROOT}/aws-hugo-example.tar.gz" \
      .; \
    cd /; \
    rm --recursive --force "${HUGO_BIN}"; \
    cd "${DOCROOT}"; \
    rm --recursive --force "${BUILD_DIR}";

COPY dockerfile/publish/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
