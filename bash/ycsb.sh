#!/usr/bin/env bash

# $1 == client index, 0, 1, 2, 3, 4
# $2 == thread count, 1, 2, 3, 4, 5, ...
# $3 == read portion: 1, 3, 5, 7, 9
# $4 == field length (in bytes), 10, 100, 500, 1000, 5000, 10000 (cannot go beyond)
# $5 == load | run | loadall

hosts=10.142.0.11,10.142.0.12,10.142.0.13,10.142.0.15,10.142.0.16 #bsr
#hosts=10.142.0.11,10.142.0.12,10.142.0.13 #bsr
#hosts=10.142.0.122,10.142.0.123,10.142.0.124,10.142.0.125,10.142.0.126 #abd
#hosts=10.142.0.122,10.142.0.123,10.142.0.124 #abd

#load_read_cl=ONE
#load_write_cl=ONE
#run_read_cl=ONE
#run_write_cl=ONE
#
load_read_cl=QUORUM
load_write_cl=QUORUM
run_read_cl=QUORUM
run_write_cl=QUORUM

#load_read_cl=ALL
#load_write_cl=ALL
#run_read_cl=ALL
#run_write_cl=ALL

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
