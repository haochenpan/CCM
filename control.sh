#!/usr/bin/env bash
. servers.sh
. credentials.sh
. functions.sh

function misc() {

#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#   "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat stop; sudo vnstat --delete --force; sudo vnstat -u -i eth0; sudo /etc/init.d/vnstat status"

#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#   "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat start; sudo /etc/init.d/vnstat status"

#    ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#    "vnstat -m"

  # ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $ycsb_path; rm start* hello ycsb*"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm ycsb*"
#     ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $who/cassandra; git status"
#     ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd $who/cassandra; ant clean; ant build"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd steve/cassandra; git status"
   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "fuser -k 7199/tcp"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "cd ~/VMCM/data; rm data_cass_t1_r9_s4096.txt"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "rm -rf herry; cd mgmt; . init.sh;"
}

function prep_ycsb() {
   scp -o StrictHostKeyChecking=no -i $sk_path ./bash/ycsb.sh $username@$1:~/VMCM/bash
}

for i in "${all_cluster_ycsb[@]}"; do
    echo $i
    misc $i
#    change_seed $i
#      prep_ycsb $i

#     clear_cass $i
#     start_cass $i
    # stop_cass $i
#     misc $i
    #
done

