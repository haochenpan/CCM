#!/usr/bin/env bash

ips="\"10.142.0.11,10.142.0.12,10.142.0.13,10.142.0.15,10.142.0.16\"" #treas
/bin/cp -f ~/CCM/setup/cassandra.yaml ~/cassandra/conf
sed -i '429 s/".*"/'"$ips"'/' ~/cassandra/conf/cassandra.yaml
