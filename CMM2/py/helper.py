import yaml
import pprint
import os

def generate_cass_yaml():
    with open('../res/cassandra.yaml') as inFile:
        # The FullLoader parameter handles the conversion from YAML
        # scalar values to Python the dictionary format
        cassandra_yaml = yaml.load(inFile, Loader=yaml.FullLoader)

    del cassandra_yaml['listen_address']
    del cassandra_yaml['rpc_address']
    cassandra_yaml['listen_interface'] = 'ens33'
    cassandra_yaml['rpc_interface'] = 'ens33'
    cassandra_yaml['auto_snapshot'] = False
    cassandra_yaml['seed_provider'][0]['parameters'][0]['seeds'] = "192.168.197.130"

    with open('../stage/cassandra.yaml', 'w') as outFile:
        documents = yaml.dump(cassandra_yaml, outFile)

generate_cass_yaml()
os.system("cp ~/CCM2/stage/cassandra.yaml ~/cassandra/conf/")

# CREATE KEYSPACE ycsb WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 1};
# CREATE TABLE ycsb.usertable ( y_id varchar primary key, field0 varchar);