# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.10

MAINTAINER Kam<cloudrewire@gmail.com>

ARG JMETER_VERSION="5.1.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_LIB	${JMETER_HOME}/lib/
ENV	JMETER_LIB_EXT	${JMETER_HOME}/lib/ext
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV GIT_USER_EMAIL "kamipatel@gmail.com"
ENV GIT_USER_NAME "kamipatel"
ENV	GIT_URL https://github.com/kamipatel/redwoods-insurance.git
ENV	GIT_PROJECT redwoods-insurance
ENV CSV_OUTPUT_PATH={$GITHUB_WORKSPACE}/metrics.csv
ENV GITHUB_TOKEN=7777171721078bbbdb91ea4218864563e7d2d5d9
ENV GITHUB_WORKSPACE={$GITHUB_WORKSPACE}

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Amsterdam"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies \	
	&& mkdir -p /home/jmeterscript  \
	&& mkdir -p /home/jmeterscript/output \
	&& cd /home/jmeterscript  \
	&& apk add --no-cache git 

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]

CMD tail -f /dev/null
