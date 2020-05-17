import sys


def generate_command():
    """
        PARAMETERS
    """
    phrase_switch = "load"
    num_of_clients = 1
    threads_per_client = 1
    read_proportion = 0.9
    field_length = 32
    num_of_records = 1000
    num_of_operations = 1000
    consistency_level = "ONE"  # for load and run, read and write
    hosts_arr = ["192.168.197.130", "192.168.197.131"]

    usage = """
    usage:
    python3 ycsb.py [load|run] <# of clients> <# of threads/client> <read portion> 
        <field length (bytes)> <# of records> <# of operations/client> <consistency level> <hosts>

    e.g.
        python3 ycsb.py load 
            # load phrase, other parameters are specified in the program

        python3 ycsb.py run 1 10 0.9 
            # run phrase, 1 clients, 10 thread/client, 90% are read operations

        python3 ycsb.py load 3 1 0.5 1024 1000 2000 ONE 10.0.0.1,10.0.0.2,10.0.0.3
            # load phrase, 3 clients, 1 thread/client, 50% are read operations (not used since "load")
            # each data field (column) has 1024 bytes, 
            # the task of 1000 records (rows) inserts are divided to 3 clients, 
            # so each of them inserts 333, 333, and 334 records, respectively,
            # 2000 operations for each client (not used since "load")
            # the consistency level for inserting record in the load phrase is ONE
            # more options see: https://bit.ly/2YW0ptt
            # Cassandra hosts are 10.0.0.1, 10.0.0.2, and 10.0.0.3 (no space between arguments)

        python3 ycsb.py run 3 1 0.5 1024 1000 2000 ONE 10.0.0.1,10.0.0.2,10.0.0.3
            # run phrase, 3 clients, 1 thread/client, 50% are read operations
            # each data field (column) has 1024 bytes, 
            # against these 1000 records, each of the 3 clients perform 2000 operations
            # the consistency level for read&write is ONE
    """

    if len(sys.argv) < 2 or len(sys.argv) > 10:
        print(usage)
        exit(0)
    hosts = ",".join(hosts_arr)
    for i, item in enumerate(sys.argv):
        if i == 0:
            pass
        elif i == 1:  # [load|run]
            phrase_switch = item
        elif i == 2:  # <# of clients>
            num_of_clients = int(item)
        elif i == 3:  # <# of threads per client>
            threads_per_client = int(item)
        elif i == 4:  # <read portion>
            read_proportion = float(item)
        elif i == 5:  # <field length (bytes)>
            field_length = int(item)
        elif i == 6:  # <# of records>
            num_of_records = int(item)
        elif i == 7:  # <# of operations>
            num_of_operations = int(item)
        elif i == 8:  # <consistency level>
            consistency_level = item
        elif i == 9:  # <hosts>
            hosts = item

    insert_start = []
    insert_count = []
    for i in range(num_of_clients):
        insert_start.append(sum(insert_count))
        if i == num_of_clients - 1:  # the last client takes all remaining records
            insert_count.append(num_of_records - sum(insert_count))
        else:
            insert_count.append(num_of_records // num_of_clients)
    # print("insert_start", insert_start)
    # print("insert_count", insert_count)
    commands = []
    for i in range(num_of_clients):
        cmd = f"""
~/ycsb-0.15.0/bin/ycsb {phrase_switch} cassandra-cql 
-p workload=com.yahoo.ycsb.workloads.CoreWorkload
-p requestdistribution=zipfian
-p fieldcount=1
-p threads={threads_per_client}
-p readproportion={read_proportion}
-p updateproportion={round(1 - read_proportion, 2)}
-p fieldlength={field_length}
-p recordcount={num_of_records}
-p operationcount={num_of_operations}
-p cassandra.readconsistencylevel={consistency_level}
-p cassandra.writeconsistencylevel={consistency_level}
-p hosts={hosts}
-p insertstart={insert_start[i]}
-p insertcount={insert_count[i]}
""".replace("\n", " ")
        commands.append(cmd)
    # process = subprocess.Popen(cmds, shell=True)
    # process.communicate(input=b'\n')
    for cmd in commands:
        print()
        print(cmd)
    return commands


if __name__ == '__main__':
    generate_command()
