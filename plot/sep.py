import os
import numpy as np
import matplotlib.pyplot as plt

data_folder = "../data/"
available_tags = ['average_read', '95_percentile_read', 'average_write', '95_percentile_write']


def get_all_exp_folders(exp_idx):
    dir_list = []
    for root, dirs, files in os.walk(data_folder):
        for dir in dirs:
            if dir.startswith(f'data_{exp_idx}_'):
                dir_list.append(os.path.join(root, dir))
    assert len(dir_list) == 3, "3 clients"
    return dir_list


def try_read_files(files):
    lines_list = []
    for file in files:
        with open(file, "r") as f:
            lines = f.readlines()
        for line in lines:
            if 'FAILED' in line:
                print(file, "try_read_files failed")
                return []
        lines_list.append(lines)

    return lines_list


def get_combined_throughput(files):
    lines_list = try_read_files(files)  # no FAIL

    tho_list_all_clients = []

    for lines in lines_list:
        tho_list_per_client = []
        for line in lines:
            if line.startswith("[OVERALL], Throughput(ops/sec), "):
                line = line.strip().split(", ")[2]
                tho_list_per_client.append(float(line))

        assert len(tho_list_per_client) == 1, "5 tries"
        tho = sum(tho_list_per_client) / len(tho_list_per_client)  # take average
        tho_list_all_clients.append(tho)

    return round(sum(tho_list_all_clients), 2)  # the sum of avgs


def get_throughput_vary_size(exp_idx, tx, sizes, rp):
    dir_list = get_all_exp_folders(exp_idx)
    plot_list = []
    for size in sizes:
        files = list(map(lambda dir_name: os.path.join(dir_name, f'data_cass_t{tx}_r{rp}_s{size}.txt'), dir_list))
        assert len(files) == 3, "3 clients"
        tho = get_combined_throughput(files)
        plot_list.append(tho)

    return plot_list


def get_throughput_vary_rp(exp_idx, tx, size, rps):
    dir_list = get_all_exp_folders(exp_idx)
    plot_list = []

    for rp in rps:
        files = list(map(lambda dir_name: os.path.join(dir_name, f'data_cass_t{tx}_r{rp}_s{size}.txt'), dir_list))
        assert len(files) == 3, "3 clients"
        tho = get_combined_throughput(files)
        plot_list.append(tho)

    return plot_list


def get_combined_latencies(files, tag):
    lines_list = try_read_files(files)  # no FAIL

    read_avg_all_clinets = []
    read_95p_all_clinets = []
    update_avg_all_clinets = []
    update_95p_all_clinets = []

    for lines in lines_list:
        read_ops_per_client = []
        read_lat_per_client_avg = []
        read_lat_per_client_95p = []
        update_ops_per_client = []
        update_lat_per_client_avg = []
        update_lat_per_client_95p = []

        for line in lines:
            if line.startswith('[READ], Operations, '):
                line = line.strip().split(", ")[2]
                read_ops_per_client.append(int(line))
            elif line.startswith('[READ], AverageLatency(us), '):
                line = line.strip().split(", ")[2]
                read_lat_per_client_avg.append(float(line))
            elif line.startswith('[READ], 95thPercentileLatency(us), '):
                line = line.strip().split(", ")[2]
                read_lat_per_client_95p.append(float(line))
            elif line.startswith('[UPDATE], Operations, '):
                line = line.strip().split(", ")[2]
                update_ops_per_client.append(int(line))
            elif line.startswith('[UPDATE], AverageLatency(us), '):
                line = line.strip().split(", ")[2]
                update_lat_per_client_avg.append(float(line))
            elif line.startswith('[UPDATE], 95thPercentileLatency(us), '):
                line = line.strip().split(", ")[2]
                update_lat_per_client_95p.append(float(line))

        num_of_try = 1
        assert num_of_try == len(read_ops_per_client) == len(update_ops_per_client), "5 tries"
        assert num_of_try == len(read_lat_per_client_avg) == len(update_lat_per_client_avg)
        assert num_of_try == len(read_lat_per_client_95p) == len(update_lat_per_client_95p)

        read_lat_per_client_avg = [(read_lat_per_client_avg[i] * read_ops_per_client[i]) for i in range(num_of_try)]
        read_lat_per_client_95p = [(read_lat_per_client_95p[i] * read_ops_per_client[i]) for i in range(num_of_try)]
        update_lat_per_client_avg = [(update_lat_per_client_avg[i] * update_ops_per_client[i]) for i in
                                     range(num_of_try)]
        update_lat_per_client_95p = [(update_lat_per_client_95p[i] * update_ops_per_client[i]) for i in
                                     range(num_of_try)]

        read_avg_all_clinets.append(sum(read_lat_per_client_avg) / sum(read_ops_per_client))
        read_95p_all_clinets.append(sum(read_lat_per_client_95p) / sum(read_ops_per_client))
        update_avg_all_clinets.append(sum(update_lat_per_client_avg) / sum(update_ops_per_client))
        update_95p_all_clinets.append(sum(update_lat_per_client_95p) / sum(update_ops_per_client))

    assert 3 == len(read_avg_all_clinets) == len(read_95p_all_clinets)
    assert 3 == len(update_avg_all_clinets) == len(update_95p_all_clinets)

    read_avg = round(sum(read_avg_all_clinets) / len(read_avg_all_clinets), 2)
    read_95p = round(sum(read_95p_all_clinets) / len(read_95p_all_clinets), 2)
    update_avg = round(sum(update_avg_all_clinets) / len(update_avg_all_clinets), 2)
    update_95p = round(sum(update_95p_all_clinets) / len(update_95p_all_clinets), 2)
    return read_avg, read_95p, update_avg, update_95p


def micro_to_milli(lats):
    return list(map(lambda x: x / 1000, lats))


def get_latency_vary_size(exp_idx, tx, sizes, rp, tag):
    assert tag in available_tags

    dir_list = get_all_exp_folders(exp_idx)
    txs_plot_list = []

    for size in sizes:
        files = list(map(lambda dir_name: os.path.join(dir_name, f'data_cass_t{tx}_r{rp}_s{size}.txt'), dir_list))
        assert len(files) == 3, "3 clients"
        ra, r9, ua, u9 = get_combined_latencies(files, tag)
        if tag == available_tags[0]:
            txs_plot_list.append(ra)
        elif tag == available_tags[1]:
            txs_plot_list.append(r9)
        elif tag == available_tags[2]:
            txs_plot_list.append(ua)
        elif tag == available_tags[3]:
            txs_plot_list.append(u9)
    return txs_plot_list


def get_latency_vary_rp(exp_idx, tx, size, rps, tag):
    assert tag in available_tags

    dir_list = get_all_exp_folders(exp_idx)
    txs_plot_list = []

    for rp in rps:
        files = list(map(lambda dir_name: os.path.join(dir_name, f'data_cass_t{tx}_r{rp}_s{size}.txt'), dir_list))
        assert len(files) == 3, "3 clients"
        ra, r9, ua, u9 = get_combined_latencies(files, tag)
        if tag == available_tags[0]:
            txs_plot_list.append(ra)
        elif tag == available_tags[1]:
            txs_plot_list.append(r9)
        elif tag == available_tags[2]:
            txs_plot_list.append(ua)
        elif tag == available_tags[3]:
            txs_plot_list.append(u9)
    return txs_plot_list


if __name__ == '__main__':
    pass

    index_list_5 = [1161, 1171, 1181, 1191]
    # index_list_5 = [1071, 1121, 1111, 1021]
    names_list_5 = ['Treas-f=0', 'Treas-f=1', "Oreas-f=0", "Oreas-f=1"]
    # names_list_5 = ['Cass-All', 'Cass-Quorum', 'Treas', "Oreas"]
    vary_size_list = [16]
    # vary_size_list = [16, 4096]
    for i, exp_idx in enumerate(index_list_5):
        for size in vary_size_list:
            # results = [names_list_5[i], "data size", size, "throughput"]
            results = [names_list_5[i]]
            tho = get_throughput_vary_size(exp_idx, 1, [size], 9)
            results.extend(tho)
            # for tag in available_tags:
                # results.append(tag)
                # lat = get_latency_vary_size(exp_idx, 1, [size], 9, tag)
                # results.extend(lat)
            print(*results, sep="\t")
