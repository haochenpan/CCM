#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

#remove_all
run_wl 1 5 100
#run_wl_vary_size 10 9
#run_wl_vary_read 10 32
download_all 841

