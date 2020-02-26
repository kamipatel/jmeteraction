# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.10

MAINTAINER Kam<cloudrewire@gmail.com>

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
