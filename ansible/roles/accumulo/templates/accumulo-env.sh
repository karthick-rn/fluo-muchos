#! /usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

{% if accumulo_major_version == '1' %}
export ACCUMULO_TSERVER_OPTS="-Xmx{{ accumulo_tserv_mem }} -Xms{{ accumulo_tserv_mem }}"
export ACCUMULO_MASTER_OPTS="-Xmx256m -Xms256m"
export ACCUMULO_MONITOR_OPTS="-Xmx128m -Xms64m"
export ACCUMULO_GC_OPTS="-Xmx128m -Xms128m"
export ACCUMULO_SHELL_OPTS="-Xmx256m -Xms64m"
export ACCUMULO_GENERAL_OPTS="-XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -Djava.net.preferIPv4Stack=true -XX:+CMSClassUnloadingEnabled"
export ACCUMULO_OTHER_OPTS="-Xmx256m -Xms64m"
export ACCUMULO_KILL_CMD='kill -9 %p'
export NUM_TSERVERS=1
{% else %}
JAVA_OPTS=("${ACCUMULO_JAVA_OPTS[@]}" '-XX:+UseConcMarkSweepGC' '-XX:CMSInitiatingOccupancyFraction=75' '-XX:+CMSClassUnloadingEnabled'
'-XX:OnOutOfMemoryError=kill -9 %p' '-XX:-OmitStackTraceInFastThrow' '-Djava.net.preferIPv4Stack=true' 
'-Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl')

case "$ACCUMULO_CMD" in
master)  JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx256m' '-Xms256m') ;;
gc)      JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx128m' '-Xms128m') ;;
tserver) JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx{{ accumulo_tserv_mem }}' '-Xms{{ accumulo_tserv_mem }}') ;;
monitor) JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx128m' '-Xms64m') ;;
shell)   JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx256m' '-Xms64m') ;;
*)       JAVA_OPTS=("${JAVA_OPTS[@]}" '-Xmx256m' '-Xms64m') ;;
esac
export JAVA_OPTS
{% endif %}

export ACCUMULO_LOG_DIR=$ACCUMULO_HOME/logs
export HADOOP_PREFIX={{ hadoop_prefix }}
export HADOOP_CONF_DIR="$HADOOP_PREFIX/etc/hadoop"
export ZOOKEEPER_HOME={{ zookeeper_home }}
export JAVA_HOME={{ java_home }}
export MALLOC_ARENA_MAX=${MALLOC_ARENA_MAX:-1}
