#!/usr/bin/env bash
. servers.sh

username="root"    # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"

cqlsh_server_local=10.142.0.17
cqlsh_server=${current[0]}
ycsb_1=${ycsb[0]}
ycsb_2=${ycsb[1]}
ycsb_3=${ycsb[2]}
dir=./data2/oreas4096
