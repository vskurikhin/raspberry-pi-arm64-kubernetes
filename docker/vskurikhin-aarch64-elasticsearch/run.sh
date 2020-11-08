#!/bin/sh

# provision elasticsearch user
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# set environment
export CLUSTER_NAME=${CLUSTER_NAME:-elasticsearch-default}
export NODE_MASTER=${NODE_MASTER:-true}
export NODE_DATA=${NODE_DATA:-true}
export HTTP_ENABLE=${HTTP_ENABLE:-true}
export MULTICAST=${MULTICAST:-true}

ES_USER="elasticsearch"
ES_GROUP="$ES_USER"
ES_HOME="/elasticsearch"
ES_HEAP_SIZE=1024
ES_MAX_OPEN_FILES=32000

# Add group and user (without creating the homedir)
echo "Add user: $ES_USER"
sudo useradd -d $ES_HOME -M -s /bin/bash -U $ES_USER
chown -R elasticsearch /elasticsearch /data

# Bump max open files for the user
sudo sh -c "echo '$ES_USER soft nofile $ES_MAX_OPEN_FILES' >> /etc/security/limits.conf"
sudo sh -c "echo '$ES_USER hard nofile $ES_MAX_OPEN_FILES' >> /etc/security/limits.conf"

# allow for memlock
ulimit -l unlimited

# run
sudo -E -u elasticsearch /elasticsearch/bin/elasticsearch
