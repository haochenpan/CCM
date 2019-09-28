#!/usr/bin/env bash

. credentials.sh
. benchmark.sh

describe
remove_all
#single_load_wl 1 9 16
#single_run_wl 1 9 16
run_wl 1 9 16
download_all 1191

count
truncate
count