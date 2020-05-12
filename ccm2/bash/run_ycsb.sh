#!/usr/bin/env bash

# $1 == client index, 0, 1, 2, 3, 4
# $2 == thread count, 1, 2, 3, 4, 5, ...
# $3 == read portion: 1, 3, 5, 7, 9
# $4 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
# $5 == load | run | loadall

#hosts=10.142.0.2,10.142.0.3,10.142.0.4,10.142.0.5,10.142.0.6,10.142.0.77,10.142.0.78 #treas
hosts=10.142.0.17,10.142.0.18,10.142.0.19,10.142.0.20,10.142.0.21,10.142.0.79,10.142.0.80 #oreas
#hosts=10.142.0.31,10.142.0.32,10.142.0.33,10.142.0.34,10.142.0.35 #cassall
#hosts=10.142.0.69,10.142.0.71,10.142.0.72,10.142.0.70,10.142.0.73 #cassquo

#load_read_cl=QUORUM
#load_write_cl=QUORUM
#run_read_cl=QUORUM
#run_write_cl=QUORUM

load_read_cl=ALL
load_write_cl=ALL
run_read_cl=ALL
run_write_cl=ALL

num_of_clients=3
row_cnt=30000  # in total
ops_cnt=100000  # per client
field_count=1
thread_index=$1
thread_count=$2  # thread count per client
read_portion=$3
field_length=$4
run_switch=$5

if [[ $run_switch == "loadall" ]]; then
  insert_start=0
  insert_count=$row_cnt
  run_switch=load
else
  insert_count=`expr $row_cnt / $num_of_clients`
  insert_start=`expr $1 \* $insert_count`
fi

echo "*********************start*************************"
echo "load read cl $load_read_cl, load write cl $load_write_cl"
echo "run read cl $run_read_cl, run write cl $run_write_cl"
echo "hosts $hosts"
echo "total rows $row_cnt, per client ops $ops_cnt"
echo "if load: insert start $insert_start, insert count $insert_count"
echo "if load: field length (in bytes) $field_length"
echo "if run: thread count $thread_count, read_portion $read_portion"

mkdir -p ~/CCM/data/

case $run_switch in
  load)
  ~/ycsb-0.15.0/bin/ycsb load cassandra-cql -P ~/CCM/ycsb/workload_${read_portion} \
  -p cassandra.readconsistencylevel=$load_read_cl \
  -p cassandra.writeconsistencylevel=$load_write_cl \
  -p recordcount=$row_cnt -p operationcount=$ops_cnt \
  -p hosts=$hosts -p fieldcount=$field_count -p fieldlength=$field_length \
  -p insertstart=$insert_start -p insertcount=$insert_count \
  -threads 1
  ;;
  run)
  ~/ycsb-0.15.0/bin/ycsb run cassandra-cql -P ~/CCM/ycsb/workload_${read_portion} \
  -p cassandra.readconsistencylevel=$run_read_cl \
  -p cassandra.writeconsistencylevel=$run_write_cl \
  -p recordcount=$row_cnt -p operationcount=$ops_cnt \
  -p hosts=$hosts -p fieldcount=$field_count -p fieldlength=$field_length \
  -threads $thread_count \
  -s >> ~/CCM/data/data_cass_t${thread_count}_r${read_portion}_s${field_length}.txt
  ;;
  *)
  echo "invalid run_switch $run_switch"
esac
echo "*********************done**************************"
