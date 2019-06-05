### current project: cassandra benchmarking's best practice
```
On GCP: create server & client virtual instances
On all remote instances: run appropriate instance init code
Local: modify servers.sh, credentials.sh, ycsb.sh, and run_bench.sh
Local: modify change_seed.sh, in control.sh: run it (some algorithms may need extra steps here)
Local: in control.sh: (clear cassandra) start cassandra
Local: in control.sh: upload ycsb.sh to all YCSB clients
On a server instance: check nodes join
On a server instance: load table schema
Local: run btest.sh
On all server instances: vnstat clear & start
On GCP: upload servers.sh, credentials.sh, and run_bench.sh to a remote controller (and benchmark.sh for the first time)
On the remote controller instance: . run_bench.sh &

```

### instance init code
```bash
sudo apt-get install -y git
cd
git clone https://github.com/haochenpan/VMCM.git
chmod +x ~/VMCM/bash/*
cd VMCM/bash
. setup.sh ycsb
#. setup.sh 0d464cd25ffbb5734f96c3082f9cc35011de3667
#. setup.sh abd
#. setup.sh abdOpt
#. setup.sh treasErasure
```

### cassandra table schemas for reference
```
CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 
                                         'replication_factor': 5};

community                                
CREATE TABLE ycsb.usertable (y_id varchar primary key, field0 varchar);

abd*
CREATE TABLE ycsb.usertable (y_id varchar primary key, field0 varchar,
                             tag varchar);
treas*
CREATE TABLE ycsb.usertable(y_id varchar PRIMARY KEY, field0 varchar, 
                            field1 varchar, tag1 varchar, 
                            field2 varchar, tag2 varchar, 
                            field3 varchar, tag3 varchar,
                            field4 varchar, tag4 varchar,
                            field5 varchar, tag5 varchar);
```


### vnstat usage for reference
```bash
sudo chown -R vnstat:vnstat /var/lib/vnstat
sudo /etc/init.d/vnstat start
# perform some IO
vnstat
sudo /etc/init.d/vnstat stop
sudo vnstat --delete --force

sudo vnstat -u -i eth0
sudo /etc/init.d/vnstat start
```

### remote controller instance
shoud have a similar codebase, i.e. in ~/VMCM:

```
|- setup/ -- id
|- data/
|- benchmark.sh
|- credentials.sh
|- run_bench.sh
|- servers.sh
```
        
### other things

download from the controller to local:
`scp -i ./setup/id -r panhi_bc_edu@35.231.79.157:VMCM/data ./data`


### known issues
SSH private key needs `chmod 400 id` before use.
In Ubuntu 14.04, sometimes nohup bg jobs (e.g. run_bench.sh) hang in ssh sessions.

