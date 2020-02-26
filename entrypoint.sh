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

echo "GIT_URL=${GIT_URL}"
echo "GIT_PROJECT=${GIT_PROJECT}"
echo "JMETER_LIB_EXT=${JMETER_LIB_EXT}"
echo "JMETER_SCRIPT_HOME=${JMETER_SCRIPT_HOME}"
echo "CSV_OUTPUT_PATH=${CSV_OUTPUT_PATH}"
echo "GIT_USER_EMAIL=${GIT_USER_EMAIL}"
echo "GIT_USER_NAME=${GIT_USER_NAME}"
echo "GITHUB_TOKEN=${GITHUB_TOKEN}"
echo "GITHUB_HOME=${GITHUB_HOME}"

git --version 

cd /home/jmeterscript
git config --global user.email ${GIT_USER_EMAIL}
git config --global user.name ${GIT_USER_NAME}

git clone ${GIT_URL} 
ls /home/jmeterscript/
ls /home/jmeterscript/${GIT_PROJECT}/jmeterinfo/

echo "Before Java code run"
java -classpath /home/jmeterscript/${GIT_PROJECT}/jmeterinfo/*:${JMETER_LIB_EXT}/*:${JMETER_LIB}/* zerotest.JmeterUtil "${JMETER_HOME}" "/home/jmeterscript/${GIT_PROJECT}/jmeterinfo/"  "${CSV_OUTPUT_PATH}"
echo "After Java code run"

echo "May be you see csv"
cat ${CSV_OUTPUT_PATH}
#cp ${CSV_OUTPUT_PATH}/* /home/jmeterscript/${GIT_PROJECT}/dist/ 
echo "Did you see csv?"

#cd /home/jmeterscript/${GIT_PROJECT}
#git add .
#git commit -m "csv output"

#git remote set-url origin https://kamipatel:${GITHUB_TOKEN}@github.com/kamipatel/redwoods-insurance.git
#git push --set-upstream origin master

echo "END Running Jmeter on date"
