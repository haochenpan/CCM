#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

remove_all
run_wl_vary_size 1 9
run_wl_vary_read 1 128
download_all 891

remove_all
run_wl_vary_size 1 9
run_wl_vary_read 1 128
download_all 892

remove_all
run_wl_vary_size 1 9
run_wl_vary_read 1 128
download_all 893

#remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
#download_all 854
#
#remove_all
#run_wl_vary_size 1 9
#run_wl_vary_read 1 128
#download_all 855


