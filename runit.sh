#!/bin/sh
cat /etc/passwd > /tmp/passwd;echo "$(id -u):x:$(id -u):$(id -g):dynamic uid:$SPARK_HOME:/bin/false" >> /tmp/passwd;export NSS_WRAPPER_PASSWD=/tmp/passwd;export NSS_WRAPPER_GROUP=/etc/group;export LD_PRELOAD=libnss_wrapper.so
/opt/spark/bin/spark-submit --master $SPARK_MASTER_ADDRESS  --class org.apache.spark.examples.SparkPi /opt/spark/examples/jars/spark-examples_2.11-2.1.0.jar 500
