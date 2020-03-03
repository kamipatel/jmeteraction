echo "END Running Jmeter on date"

#!/bin/bash
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
#
# This script expects the standdard JMeter command parameters.
#
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

# Keep entrypoint simple: we must pass the standard JMeter arguments
echo $@
#jmeter $@

# install google chrome
echo "install google chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub 
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
apt-get -y update
apt-get install -y google-chrome-stable

# install chromedriver
echo "install chromedriver"
apt-get install -yqq unzip
wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

echo "chrome webdriver installed!"

# set display port to avoid crash
ENV DISPLAY=:99

git --version 

#cd /home/jmeterscript
git config --global user.email ${GIT_USER_EMAIL}
git config --global user.name ${GIT_USER_NAME}

git clone ${GIT_URL} 
ls ${GIT_PROJECT}/jmeterinfo/

mkdir output
chmod 777 output

echo ${JMX_FILE_NAME}

echo "Before Java code run"
java -classpath ${GIT_PROJECT}/jmeterinfo/*:${JMETER_LIB_EXT}/*:${JMETER_LIB}/* zerotest.JmeterUtil "${JMETER_HOME}" "${GIT_PROJECT}/jmeterinfo/"  "${CSV_OUTPUT_PATH}" ${JMX_FILE_NAME}
echo "After Java code run"

cat ${CSV_OUTPUT_PATH}

echo "END Running Jmeter on date"
