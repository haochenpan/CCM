#!/usr/bin/env bash

ips="\"10.142.0.47\""
/bin/cp -f ~/VMCM/setup/cassandra.yaml ~/cassandra/conf
sed -i '429 s/".*"/'"$ips"'/' ~/cassandra/conf/cassandra.yaml
