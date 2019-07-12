#!/usr/bin/env bash
. servers.sh

username="panhi_bc_edu" # the username when ssh in an instance
sk_path=./setup/id # the name of the ssh key
ycsb_path="~/ycsb-0.15.0"
cqlsh_path="~/cassandra/bin/cqlsh"

# abd
#cqlsh_server_local=10.142.0.62
#cqlsh_server=${abd_cluster[0]}
#ycsb_1=${abd_cluster_ycsb[0]}
#ycsb_2=${abd_cluster_ycsb[1]}
#ycsb_3=${abd_cluster_ycsb[2]}

# abdOpt
#cqlsh_server_local=10.142.15.204
#cqlsh_server=${opt_cluster[0]}
#ycsb_1=${opt_cluster_ycsb[0]}
#ycsb_2=${opt_cluster_ycsb[1]}
#ycsb_3=${opt_cluster_ycsb[2]}

# all
cqlsh_server_local=10.142.15.212
cqlsh_server=${all_cluster[0]}
ycsb_1=${all_cluster_ycsb[0]}
ycsb_2=${all_cluster_ycsb[1]}
ycsb_3=${all_cluster_ycsb[2]}

# dsk
#cqlsh_server_local=10.142.15.199
#cqlsh_server=${dsk_cluster[0]}
#ycsb_1=${dsk_cluster_ycsb[0]}
#ycsb_2=${dsk_cluster_ycsb[1]}
#ycsb_3=${dsk_cluster_ycsb[2]}

# quo
#cqlsh_server_local=10.142.15.223
#cqlsh_server=${quo_cluster[0]}
#ycsb_1=${quo_cluster_ycsb[0]}
#ycsb_2=${quo_cluster_ycsb[1]}
#ycsb_3=${quo_cluster_ycsb[2]}

# nohup /bin/bash run_bench.sh &

