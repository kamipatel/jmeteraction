# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.10

VOLUME /output

#RUN mkdir output
RUN chmod +x output

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh","/entrypoint.sh"]