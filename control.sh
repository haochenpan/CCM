#!/usr/bin/env bash
. servers.sh
. credentials.sh
. functions.sh

function misc() {
#  ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/ycsb-0.15.0; rm data*"
  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/ycsb-0.15.0; cat ycsb*"
  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/ycsb-0.15.0; cat start*"
  
  
  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/ycsb-0.15.0; rm data*;"
  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ls"
  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $ycsb_path; rm start* hello ycsb*"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm ycsb*"
#     ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $who/cassandra; git status"
#     ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $who/cassandra; ant clean; ant build"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd steve/cassandra; git status"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "fuser -k 7199/tcp"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm -rf herry;"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm -rf herry; cd mgmt; . init.sh;"
}

function prep_ycsb() {
   scp -o StrictHostKeyChecking=no -i $sk_path ./bash/ycsb.sh $username@$1:~/VMCM/bash
}

for i in "${test_cluster[@]}"; do
    echo $i
#    misc $i
#    change_seed $i
#        load_cass $1
#     clear_cass $i
#     start_cass $i
    # stop_cass $i
#     misc $i
      prep_ycsb $i
    #
done

