#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

echo $cqlsh_server
echo $cqlsh_server_local
echo $ycsb_1
describe

remove_all
run_wl 1 9 32
download_all 500

count
truncate
count