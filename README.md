## Cassandra Cluster Management: Deployment hard-won wisdom & Benchmarking best practices

> I clone this repo when initializing a new VM for Cassandra benchmarking (using YCSB). <br>
This repo is also a toolbox for managing these VMs and this readme file documents hard-won wisdom and best practices I realized. 


### Table of Contents
**[Usage](#Usage)**<br>
**[Benchmark Workflow](#Benchmark-Workflow)**<br>
**[Add an Algorithm](#Add-an-Algorithm)**<br>
**[Change the Workload](#Change-the-Workload)**<br>
**[When Servers Reboot](#When-Servers-Reboot)**<br>
**[Gotchas](#Gotchas)**<br>
**[Other Things](#Other-Things)**<br>
**[More Best Practices](#More-Best-Practices)**<br>
**[Future Works](#Future-Works)**<br>


### Usage

The code blocks below is quite frequently used so I put it at the top of this file.
More details are in **[Benchmark Workflow](#Benchmark-Workflow)**.

> `setup.sh` currently support installing YCSB, algorithms like ABD, ABD-Opt, Treas-Opt, and the community version they forked from. 

See [Add an Algorithm](#Add-an-Algorithm) when you want to benchmark a new algorithm. <br>
See [Change the Workload](#Change-the-Workload) when you want to modify existing workloads or add a new one. <br>
These two sections serve as a great tour in this codebase. <br>

```bash
sudo apt-get install -y git  # install git
cd  # or anywhere you want to install
git clone https://github.com/haochenpan/CCM.git  # git clone this repo
chmod +x ~/CCM/bash/*  # for using this scripts through SSH tunnels
cd CCM/bash
. setup.sh ycsb

#. setup.sh 0d464cd25ffbb5734f96c3082f9cc35011de3667

#. setup.sh 8ed1a3066d538c0313e481482726e064b7b571c8

# choose a algorithm (through a git branch tag) or YCSB to install
#. setup.sh abd
#. setup.sh abdOpt
#. setup.sh treasErasure
```


### Benchmark Workflow


- On GCP: create new virtual instances for Cassandra servers and YCSB clients. Names could be Cass-all-1, Cass-all-2, Cass-all-3, Cass-all-ycsb-1, Cass-all-ycsb-2, and Cass-all-ycsb-3
- On all remote instances: run appropriate initialization code, see the above section
- On a local computer: clone this repo, modify (or create) `servers.sh`, `credentials.sh`, `ycsb.sh`, and `run_bench.sh`. `servers.sh` format see below
- On a local computer: modify `bash/change_seed.sh` to server ips, in `control.sh`: run it (some algorithms may need extra steps here)
- On a local computer: in `control.sh`: (clear cassandra and) start cassandra
- On a local computer: in `control.sh`: upload `ycsb.sh` to all YCSB clients (through prepare_ycsb)
- On a server instance: check nodes join and load the table schema (see below)
- On a local computer or a remote controller: run `btest.sh`
    - see the second last step and below about the remote controller
- If use vnStat, in `control.sh`, clear and start vnStart (through misc)
- On GCP: upload `servers.sh`, `credentials.sh`, and `run_bench.sh` to a remote controller (and `benchmark.sh` for the first time)
- On the remote controller instance: `nohup . run_bench.sh &`


As you can see, for the most of the time, we are working with `control.sh`. <br>
I feel that I'd better make some short commands readily available, so they are commented out lines in control.sh.

#### `servers.sh` example content

```
abd_cluster=(
35.231.111.138
34.73.116.123
34.74.107.157
35.231.193.238
35.237.236.187
)

abd_cluster_ycsb=(
35.243.215.174
34.74.192.43
35.227.30.246
)

```

#### cassandra table schemas
create a keyspace and the corresponding schema of an algorithm
```
CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy',
                                         'replication_factor': 3};
                                         
CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy',
                                         'replication_factor': 5};

community                                
CREATE TABLE ycsb.usertable ( y_id varchar primary key, field0 varchar);

abd*
CREATE TABLE ycsb.usertable ( y_id varchar primary key, field0 varchar,
                              tag varchar);
treas*
CREATE TABLE ycsb.usertable ( y_id varchar PRIMARY KEY, field0 varchar,
                              field1 varchar, tag1 varchar,
                              field2 varchar, tag2 varchar,
                              field3 varchar, tag3 varchar,
                              field4 varchar, tag4 varchar,
                              field5 varchar, tag5 varchar);

oreas*
CREATE TABLE ycsb.usertable( y_id varchar PRIMARY KEY, field0 varchar, 
                              field1 varchar, tag1 bigint, 
                              field2 varchar, tag2 bigint, 
                              field3 varchar, tag3 bigint);

treas2
CREATE TABLE ycsb.usertable( y_id varchar PRIMARY KEY, field0 varchar, 
                             field1 varchar, tag1 varchar, 
                             field2 varchar, tag2 varchar, 
                             field3 varchar, tag3 varchar);

                            
generic 
CREATE TABLE ycsb.usertable ( y_id varchar PRIMARY KEY, field0 varchar,
                              z_value int, writer_id varchar);

sbq
CREATE TABLE ycsb.usertable ( y_id varchar PRIMARY KEY, field0 varchar,
                              ts int);
      
causal-3
CREATE TABLE ycsb.usertable ( y_id varchar PRIMARY KEY, field0 varchar,
                              vcol0 int, vcol1 int, vcol2 int,
                              sendfrom int);
    
causal-5
CREATE TABLE ycsb.usertable ( y_id varchar PRIMARY KEY, field0 varchar,
                              vcol0 int, vcol1 int, vcol2 int, 
                              vcol3 int, vcol4 int, sendfrom int);
```

#### the remote controller instance
shoud have a similar codebase, i.e. in ~/CCM, need to have:

```
|- setup/ -- id
|- data/
|- benchmark.sh
|- credentials.sh
|- run_bench.sh
|- servers.sh
```

### Add an Algorithm

In `setup.sh`, follow the case switch pattern in function `install_cass`  to add a case entry, so that a command like `. setup.sh my_algorithm` on terminal would pick up this case. <br>
You may also need to add a table schema for this algorithm.


### Change the Workload
In folder `ycsb`, define a new YCSB workload. <br>
In `bash/ycsb.sh`, you can override some behavior of the workload by changing variable parameters.

### When Servers Reboot

- run `rm ~/.ssh/known_hosts` when server ip changes

### Gotchas

- perform `chmod 400 id` on SSH private key for the first time.
- In Ubuntu 14.04, sometimes foreground jobs (e.g. run_bench.sh, btest.sh) hang in ssh sessions but not background jobs (i.e. use nohup ... &).


### More Best Practices

- download from the controller to local: `scp -i ./setup/id -r panhi_bc_edu@server_ip:VMCM/data ./data`
- now we do ssh-keygen -m PEM -f id -C root on MacOS to generate SSH keys
### Future Works

- the use of google cloud console & use a command to populate an instance
- project wide ssh key
- `control.sh ` -> python + bash 

ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@35.243.201.187
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@35.227.79.163
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@34.74.202.53
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@34.73.73.11
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@35.231.102.168

ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@35.237.204.12
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@34.73.232.181
ssh -o StrictHostKeyChecking=no -i ~/Desktop/Cassandra-Cluster-Management/setup/id root@34.74.145.108

~/Syrupy/scripts/syrupy.py --interval=5 --poll-command='.*java' &
vnstat -l


./cqlsh 10.142.0.2 -e "CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 7};"
./cqlsh 10.142.0.17 -e "CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 7};"
./cqlsh 10.142.0.17 -e "CREATE TABLE ycsb.usertable( y_id varchar PRIMARY KEY, field0 varchar, field1 varchar, tag1 bigint, field2 varchar, tag2 bigint, field3 varchar, tag3 bigint);"
./cqlsh 10.142.0.2 -e "CREATE TABLE ycsb.usertable( y_id varchar PRIMARY KEY, field0 varchar, field1 varchar, tag1 varchar, field2 varchar, tag2 varchar, field3 varchar, tag3 varchar);"
./cqlsh 10.142.0.31 -e "CREATE TABLE ycsb.usertable ( y_id varchar primary key, field0 varchar);"


