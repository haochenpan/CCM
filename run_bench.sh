#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
run_wl_vary_thread 9 32
download_all 1201

remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
run_wl_vary_thread 9 32
download_all 1202
#
#remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
#run_wl_vary_thread 9 32
#download_all 1203

#remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
#run_wl_vary_thread 9 32
#download_all 1204

#remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
#run_wl_vary_thread 9 32
#download_all 1205


