#!/usr/bin/env bash

. ../cass-cluster-mgmt/credentials.sh
. benchmark.sh

echo $cqlsh_path
echo $cqlsh_server
echo $cqlsh_server_local
echo $ycsb_1
#describe

remote_all
run_wl 10 9 32
download_all 500

count
truncate
count