#!/usr/bin/env bash

ips="\"10.140.0.28\""
/bin/cp -f ~/VMCM/setup/cassandra.yaml ~/cassandra/conf
sed -i '429 s/".*"/'"$ips"'/' ~/cassandra/conf/cassandra.yaml
