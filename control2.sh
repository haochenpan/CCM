#!/usr/bin/env bash
. servers.sh
. credentials.sh
. functions.sh
. benchmark.sh

mkdir -p $dir/load
mkdir -p $dir/run

function before() {
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm syrupy* mem* band*"
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "~/Syrupy/scripts/syrupy.py --interval=5 --poll-command='.*java' -S > mem_$1.txt"
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "vnstat -l > band_$1.txt &"
}

function after_load() {
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "killall -2 python"
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "killall -2 vnstat"
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:~/mem* $dir/load
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:~/band* $dir/load
}

function after_run() {
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "killall -2 python"
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "killall -2 vnstat"
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:~/mem* $dir/run
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:~/band* $dir/run
}

function load() {
  for i in "${current[@]}"; do
    echo $i
    before $i
  done
  single_load_wl $1 $2 $3
  for i in "${current[@]}"; do
    echo $i
    after_load $i
  done
}

function run() {
  for i in "${current[@]}"; do
    echo $i
    before $i
  done
  single_run_wl $1 $2 $3
  for i in "${current[@]}"; do
    echo $i
    after_run $i
  done
}

#remove_all
#load 1 9 16
#run 1 9 16
load 1 9 4096
run 1 9 4096
download_all 1021

