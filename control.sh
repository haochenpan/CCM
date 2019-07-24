#!/usr/bin/env bash
. servers.sh
. credentials.sh
. functions.sh

function misc() {

   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
   "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat stop; sudo vnstat --delete --force; sudo vnstat -u -i eth0; sudo /etc/init.d/vnstat status"

   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
   "sudo chown -R vnstat:vnstat /var/lib/vnstat; sudo /etc/init.d/vnstat start; sudo /etc/init.d/vnstat status"

#    ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
#    "vnstat -m"

#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "ps -fe | grep java"
#   ssh -n -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "fuser -k 7199/tcp"
#   scp -i ./setup/id -r panhi_bc_edu@$1:"/home/panhi_bc_edu/cassandra/logs/logs_$1.zip" ./data
}

function prep_ycsb() {
   scp -o StrictHostKeyChecking=no -i $sk_path ./bash/ycsb.sh $username@$1:~/VMCM/bash
}

for i in "${dsk_cluster[@]}"; do
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

