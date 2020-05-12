#!/usr/bin/env bash
. servers.sh

username="root"    # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"

#cqlsh_server_local=10.142.0.31
#cqlsh_server=${current[0]}
#ycsb_1=${ycsb[0]}
#ycsb_2=${ycsb[1]}
#ycsb_3=${ycsb[2]}
#dir=./data2/oreas216

#cqlsh_server_local=10.142.0.31
#cqlsh_server=${cassall[0]}
#cqlsh_server=${current[0]}
#ycsb_1=${cassallycsb[0]}
#ycsb_2=${cassallycsb[1]}
#ycsb_3=${cassallycsb[2]}
#dir=./data2/cassquo34096

cqlsh_server_local=10.142.0.111
cqlsh_server=${may_cluster[0]}
ycsb_1=${may_cluster_ycsb[0]}
ycsb_2=${may_cluster_ycsb[1]}
ycsb_3=${may_cluster_ycsb[2]}
#dir=./data2/oreas24096
#
#cqlsh_server_local=10.142.0.2
#cqlsh_server=${treas[0]}
#ycsb_1=${treasycsb[0]}
#ycsb_2=${treasycsb[1]}
#ycsb_3=${treasycsb[2]}
#dir=./data2/treas24096

#
#cqlsh_server_local=10.142.0.71
#cqlsh_server=${current[0]}
#ycsb_1=${cassquoycsb[0]}
#ycsb_2=${cassquoycsb[1]}
#ycsb_3=${cassquoycsb[2]}
#dir=./data2/cassquo24096
