#!/usr/bin/env bash

ips="\"10.142.0.52,10.142.0.53,10.142.0.54,10.142.0.55,10.142.0.56\""
/bin/cp -f ~/VMCM/setup/cassandra.yaml ~/cassandra/conf
sed -i '429 s/".*"/'"$ips"'/' ~/cassandra/conf/cassandra.yaml
