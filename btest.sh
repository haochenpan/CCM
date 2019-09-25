#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

mkdir -p $dir/load
mkdir -p $dir/run

#describe
#remove_all
single_load_wl 1 9 16
#single_run_wl 1 9 16
#download_all 500

#count
#truncate
#count