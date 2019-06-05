#!/usr/bin/env bash
. credentials.sh

function change_seed() {
  ssh -o StrictHostKeyChecking=no -i $sk_path $username@$1 'bash -s' < ./bash/change_seed.sh
}

function load_cass() {

  ssh -o StrictHostKeyChecking=no -i $sk_path $username@$1 'bash -s' < ./bash/load.sh
}

function start_cass() {
	ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "~/cassandra/bin/cassandra"
}

function stop_cass() {
  nodetool="~/cassandra/bin/nodetool"
  do_action="$nodetool drain &> /dev/null; $nodetool stopdaemon &> /dev/null"
  ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 $do_action
}

function clear_cass() {
  do_action="rm ~/cassandra/data -rf; rm ~/cassandra/logs -rf"
  ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 $do_action
}
