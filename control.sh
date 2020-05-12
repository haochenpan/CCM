#!/usr/bin/env bash
. servers.sh
. credentials.sh
. functions.sh
. benchmark.sh

function misc() {

#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#    "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat stop; sudo vnstat --delete --force; sudo vnstat -u -i eth0; sudo /etc/init.d/vnstat status"
#
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#    "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat start; sudo /etc/init.d/vnstat status"
#
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#    "vnstat -m"
#
  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git reset --hard && git status"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git checkout cassandra-3.11"
#
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git status"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git checkout bsr"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git checkout 0d464cd25ffbb5734f96c3082f9cc35011de3667"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm cassandra -rf"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "git clone https://github.com/yingjianwu199868/cassandra.git"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git checkout OreasNoLog"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git checkout OreasNoLog && ant build && git status"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && git status"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && ant build"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd cassandra && ant clean && ant build
#          -f ~/CCM/setup/build.xml"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "fuser -k 7199/tcp"
#  scp -i $sk_path-r $username:"/home/panhi_bc_edu/cassandra/logs/logs_$1.zip" ./data
#  scp -i $sk_path ./setup/cassandra.yaml root@$1:~/CCM/setup/
}

function prep_ycsb() {
  scp -o StrictHostKeyChecking=no -i $sk_path ./bash/ycsb.sh $username@$1:~/CCM/bash
}

for i in "${bsr_servers[@]}"; do
#  echo $i
  misc $i
#  change_seed $i
#  prep_ycsb $i
#  clear_cass $i
#  start_cass $i
#  stop_cass $i
#  misc $i
done

#./bin/cqlsh 10.0.0.1 -e "create keyspace ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 5};"
#./bin/cqlsh 10.0.0.1 -e "CREATE TABLE ycsb.usertable(y_id varchar PRIMARY KEY, field0 varchar, tag varchar);”
