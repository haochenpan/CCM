#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

remove_all
run_wl_vary_size 1 9
#run_wl_vary_read 1 512
download_all 841

