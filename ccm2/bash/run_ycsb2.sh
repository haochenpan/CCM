#!/usr/bin/env bash

# $1 == client index: 0, 1, 2, 3, 4
# $2 == thread count: 1, 2, 3, 4, 5, ...
# $3 == read portion: 1, 3, 5, 7, 9
# $4 == field length (in bytes): 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
# $5 == load | run | loadall
# $6 == hosts: examples see below
# $7 == consistency_level: QUORUM, ALL, ... see https://bit.ly/2YW0ptt

#hosts=10.142.0.2,10.142.0.3,10.142.0.4,10.142.0.5,10.142.0.6,10.142.0.77,10.142.0.78 #treas

workload_dir=../ycsb/
data_dir=../data/
num_of_clients=3
row_cnt=30000   # total rows in the db
ops_cnt=100000  # per client operation
field_count=1   # the num. of columns
thread_count=$2 # the num. of threads
read_portion=$3
field_length=$4
run_switch=$5
hosts=$6
load_read_cl=$7
load_write_cl=$7
run_read_cl=$7
run_write_cl=$7

if [[ $run_switch == "loadall" ]]; then
  insert_start=0
  insert_count=$row_cnt
  run_switch=load
else
  insert_count=$(expr $row_cnt / $num_of_clients)
  insert_start=$(expr $1 \* $insert_count)
fi

echo "*********************start*************************"
echo "task: $5, num_of_clients $num_of_clients, client idx: $1, "
echo "total rows $row_cnt, per client ops $ops_cnt"
echo "if run: thread count $thread_count, read_portion $read_portion"
echo "if load: field length (in bytes) $field_length"
echo "if load: insert start $insert_start, insert count $insert_count"
echo "hosts: $hosts"
echo "consistency level: $6"

case $run_switch in
load)
  ~/ycsb-0.15.0/bin/ycsb load cassandra-cql -P $workload_dir/workload_${read_portion} \
    -p cassandra.readconsistencylevel=$load_read_cl \
    -p cassandra.writeconsistencylevel=$load_write_cl \
    -p recordcount=$row_cnt -p operationcount=$ops_cnt \
    -p hosts=$hosts -p fieldcount=$field_count -p fieldlength=$field_length \
    -p insertstart=$insert_start -p insertcount=$insert_count \
    -threads 1
  ;;
run)
  ~/ycsb-0.15.0/bin/ycsb run cassandra-cql -P $workload_dir/workload_${read_portion} \
    -p cassandra.readconsistencylevel=$run_read_cl \
    -p cassandra.writeconsistencylevel=$run_write_cl \
    -p recordcount=$row_cnt -p operationcount=$ops_cnt \
    -p hosts=$hosts -p fieldcount=$field_count -p fieldlength=$field_length \
    -threads $thread_count \
    -s >>$data_dir/data_cass_t${thread_count}_r${read_portion}_s${field_length}.txt
  ;;
*)
  echo "invalid run_switch $run_switch"
  ;;
esac
echo "*********************done**************************"
