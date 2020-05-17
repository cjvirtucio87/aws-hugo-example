FROM centos:latest

ENV DOCROOT /var/www/html

USER root

RUN set -e; \
    yum update -y; \
    yum install httpd -y; \
    yum clean all;

COPY dockerfile/run/docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
