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
# java -classpath ${GIT_PROJECT}/jmeterinfo/*:${JMETER_LIB_EXT}/*:${JMETER_LIB}/* zerotest.JmeterUtil "${JMETER_HOME}" "${GIT_PROJECT}/jmeterinfo/"  "${CSV_OUTPUT_PATH}" ${JMX_FILE_NAME}

java -classpath ${GIT_PROJECT}/jmeterinfo/*.jar:${JMETER_LIB_EXT}/*.jar:${JMETER_LIB_JUNIT}/*.jar:${JMETER_LIB}/*.jar org.junit.runner.JUnitCore com.jcg.selenium.GoogleSearchTest 

echo "After Java code run"

cat ${CSV_OUTPUT_PATH}

echo "END Running Jmeter on date"
