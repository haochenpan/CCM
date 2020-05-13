#!/usr/bin/env bash
. credentials.sh

function truncate() {
  ssh -n -o StrictHostKeyChecking=no -i "$sk_path" "$username"@"$cqlsh_server" \
  "$cqlsh_path $cqlsh_server_local 9042 -e 'TRUNCATE ycsb.usertable;'"
}

function describe() {
  ssh -n -o StrictHostKeyChecking=no -i "$sk_path" "$username"@"$cqlsh_server" \
  "$cqlsh_path $cqlsh_server_local 9042 -e 'describe KEYSPACE ycsb;'"
}

function count() {
  count=$(ssh -n -o StrictHostKeyChecking=no -i "$sk_path" "$username"@"$cqlsh_server" \
  "$cqlsh_path $cqlsh_server_local 9042 -e 'SELECT COUNT(*) FROM ycsb.usertable;'")
  echo "$count"
}

function run_trail_at_client() {
  # $1 == client index, 0, 1, 2, 3, 4
  # $2 == thread count, 1, 2, 3, 4, 5, ...
  # $3 == read portion: 1, 3, 5, 7, 9
  # $4 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
  # $5 == load | run | loadall
  # $6 == YCSB client public ip
  ssh -o StrictHostKeyChecking=no -i "$sk_path" "$username"@"$6" "~/CCM/bash/ycsb.sh $1 $2 $3 $4 $5"
}

function run_at_all_clients() {
  run_trail_at_client 0 "$1" "$2" "$3" "$4" "$ycsb_1" &
  run_trail_at_client 1 "$1" "$2" "$3" "$4" "$ycsb_2" &
  run_trail_at_client 2 "$1" "$2" "$3" "$4" "$ycsb_3" &
  wait
}

function run_wl() {
  # $1 == thread count, 1, 2, 3, 4, 5, ...
  # $2 == read portion: 1, 3, 5, 7, 9
  # $3 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
    truncate
    run_at_all_clients "$1" "$2" "$3" load
    run_at_all_clients "$1" "$2" "$3" run
}

function single_load_wl() {
  # $1 == thread count, 1, 2, 3, 4, 5, ...
  # $2 == read portion: 1, 3, 5, 7, 9
  # $3 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
    truncate
    run_at_all_clients "$1" "$2" "$3" load
    count
}

function single_run_wl() {
  # $1 == thread count, 1, 2, 3, 4, 5, ...
  # $2 == read portion: 1, 3, 5, 7, 9
  # $3 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
    run_at_all_clients "$1" "$2" "$3" run

}

function run_wl_5_times() {
    echo "run wl with thd $1, read $2, size $3"
    run_wl $1 $2 $3
    run_wl $1 $2 $3
    run_wl $1 $2 $3
    run_wl $1 $2 $3
    run_wl $1 $2 $3
}

function run_wl_vary_read() {
    # $1 == thread count, 1, 2, 3, 4, 5, ...
    # $2 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
    for i in 1 5 9
    do
      run_wl_5_times "$1" "$i" "$2"
    done
}

function run_wl_vary_size() {
   # $1 == thread count, 1, 2, 3, 4, 5, ...
   # $2 == read portion: 1, 3, 5, 7, 9
   for i in 16 64 256 1024 2048 4096
#   for i in 16 64 256 1024 2048 4096
#   for i in 2048 4096 8192 16384 32768 65536
#   for i in 2048 4096 8192 16384 32768
   do
     run_wl_5_times "$1" "$2" "$i"
   done
}

function run_wl_vary_thread() {
  # $1 == read portion: 1, 3, 5, 7, 9
  # $2 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
  for thread in 2 4 6 8 10 12
#  for thread in 2
  do
     run_wl_5_times "$thread" "$1" "$2"
  done
}

function download_data() {
  ssh -n -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/CCM/data; zip data_${2}_${1}.zip data_cass_t*"
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:~/CCM/data/data_${2}_${1}.zip  ./data/
}

function rm_data() {
  ssh -n -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/CCM/data; rm data*"
}

function download_all() {
    download_data $ycsb_1 $1
    download_data $ycsb_2 $1
    download_data $ycsb_3 $1
}

function remove_all() {
    rm_data $ycsb_1
    rm_data $ycsb_2
    rm_data $ycsb_3
}

