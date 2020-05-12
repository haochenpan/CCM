#!/usr/bin/env bash
. servers.sh

username="root"    # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"

cqlsh_server_local=10.142.0.11
cqlsh_server=${bsr_servers[0]}
ycsb_1=${bsr_servers_ycsb[0]}
ycsb_2=${bsr_servers_ycsb[1]}
ycsb_3=${bsr_servers_ycsb[2]}
#dir=./data2/bsr_test # for vnstats and syrupy
