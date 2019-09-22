#!/usr/bin/env bash
. servers.sh

username="root" # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"

# cass-all
cqlsh_server_local=10.142.0.11
cqlsh_server=${cass_all[0]}
ycsb_1=${ycsb_one[0]}
ycsb_2=${ycsb_one[1]}
ycsb_3=${ycsb_one[2]}

# nohup /bin/bash run_bench.sh &

