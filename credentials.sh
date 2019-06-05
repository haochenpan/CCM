#!/usr/bin/env bash
. servers.sh

username="panhi_bc_edu" # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"


cqlsh_server_local=10.142.0.8
cqlsh_server=${test_cluster[0]}
ycsb_1=${test_cluster_y[0]}
ycsb_2=${test_cluster_y[1]}
ycsb_3=${test_cluster_y[2]}


# nohup /bin/bash run_bench.sh &

