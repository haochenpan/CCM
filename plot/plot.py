import os
import numpy as np
import matplotlib.pyplot as plt

fig_size = (6.5, 6.5)
legend_prop = {'size': 13}
legend_ncol = 2
data_folder = "../data/"
available_tags = ['average_read', '95_percentile_read', 'average_write', '95_percentile_write']
markers = ["^","P",  "D", "s"]
colors = ['tab:orange', 'tab:red', 'tab:cyan', 'tab:blue']
# colors = ['tab:brown', 'tab:cyan', 'tab:pink', 'tab:gray', 'tab:blue']
# colors = ['tab:orange', 'tab:red', 'tab:cyan', 'tab:gray', 'tab:blue', 'tab:green']
linestyle = '-'
linewidth = 2
markersize = 8
fontsize = 12


# vary_txs_list = [2, 4, 6, 8, 10, 12]
# vary_szs_list = [1, 4, 16, 64, 256, 1024]
# vary_rps_list = [1, 3, 5, 7, 9]


#
# def vary_txs_x_label(num_of_server, size, rp):
#     return ("threads/client\n"
#             f"(LAN, {num_of_server} Cass* servers, "
#             f"{size} byte data, "
#             f"write ratio: {(10 - rp) / 10})")


def vary_szs_x_label(num_of_server, tx, rp):
    return ("value size (B)\n"
            f"(LAN, {num_of_server} Cassandra servers, "
            f"3 1-thread YCSB clients, "
            f"write ratio: {(10 - rp) / 10})")


def vary_rps_x_label(num_of_server, tx, size):
    return ("write ratio\n"
            f"(LAN, {num_of_server} Cassandra servers, "
            f"3 1-thread YCSB clients, "
            f"{size} byte data)")


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

        assert len(tho_list_per_client) == 5, "5 tries"
        tho = sum(tho_list_per_client) / len(tho_list_per_client)  # take average
        tho_list_all_clients.append(tho)

    return round(sum(tho_list_all_clients), 2)  # the sum of avgs


#
# def get_throughput_vary_thread(exp_idx, txs, size, rp):
#     dir_list = get_all_exp_folders(exp_idx)
#     plot_list = []
#
#     for tx in txs:
#         files = list(map(lambda dir_name: os.path.join(dir_name, f'data_cass_t{tx}_r{rp}_s{size}.txt'), dir_list))
#         assert len(files) == 3, "3 clients"
#         tho = get_combined_throughput(files)
#         plot_list.append(tho)
#
#     return plot_list


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

        assert 5 == len(read_ops_per_client) == len(update_ops_per_client), "5 tries"
        assert 5 == len(read_lat_per_client_avg) == len(update_lat_per_client_avg)
        assert 5 == len(read_lat_per_client_95p) == len(update_lat_per_client_95p)

        read_lat_per_client_avg = [(read_lat_per_client_avg[i] * read_ops_per_client[i]) for i in range(5)]
        read_lat_per_client_95p = [(read_lat_per_client_95p[i] * read_ops_per_client[i]) for i in range(5)]
        update_lat_per_client_avg = [(update_lat_per_client_avg[i] * update_ops_per_client[i]) for i in range(5)]
        update_lat_per_client_95p = [(update_lat_per_client_95p[i] * update_ops_per_client[i]) for i in range(5)]

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


#
# def get_latency_vary_thread(exp_idx, txs, size, rp, tag):
#     assert tag in available_tags
#
#     dir_list = get_all_exp_folders(exp_idx)
#     txs_plot_list = []
#
#     for tx in txs:
#         files = list(map(lambda dir_name: os.path.join(dir_name, f'data_t{tx}_r{rp}_s{size}.txt'), dir_list))
#         assert len(files) == 3, "3 clients"
#         ra, r9, ua, u9 = get_combined_latencies(files, tag)
#         if tag == available_tags[0]:
#             txs_plot_list.append(ra)
#         elif tag == available_tags[1]:
#             txs_plot_list.append(r9)
#         elif tag == available_tags[2]:
#             txs_plot_list.append(ua)
#         elif tag == available_tags[3]:
#             txs_plot_list.append(u9)
#     return txs_plot_list


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


#
# def plot_throughput_vary_thread(exp_idxs, labels, txs, size, rp, num_of_server, fig_num):
#     assert len(exp_idxs) == len(labels)
#     alo_lists = [get_throughput_vary_thread(idx, txs, size, rp) for idx in exp_idxs]
#
#     fig, axs = plt.subplots(figsize=fig_size)
#
#     for j, alo_list in enumerate(alo_lists):
#         axs.plot(txs, alo_list, colors[j], marker=markers[j], label=labels[j],
#                  linestyle=linestyle, linewidth=linewidth, markersize=markersize)
#
#     axs.legend(loc="upper left", ncol=legend_ncol, prop=legend_prop)  ##
#     axs.set_xlabel(vary_txs_x_label(num_of_server, size, rp), fontsize=fontsize)
#     plt.ylim(0, 45000)
#
#     axs.set_ylabel("throughput (ops/sec)", fontsize=fontsize)
#     plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
#     plt.tight_layout()
#     plt.savefig(f"LAN {fig_num} throughput, vary thread, {num_of_server} svrs")
#     plt.show()


def plot_throughput_vary_size(exp_idxs, labels, tx, sizes, rp, num_of_server, fig_num):
    assert len(exp_idxs) == len(labels)
    alo_lists = [get_throughput_vary_size(idx, tx, sizes, rp) for idx in exp_idxs]

    fig, axs = plt.subplots(figsize=fig_size)

    for j, alo_list in enumerate(alo_lists):
        axs.plot(sizes, alo_list, colors[j], marker=markers[j], label=labels[j],
                 linestyle=linestyle, linewidth=linewidth, markersize=markersize)
    # axs.legend(loc='upper center', bbox_to_anchor=(0.5, 1),
    #       ncol=4, fancybox=True, shadow=True, prop={'size': 8})  ##

    axs.legend(loc='upper left', ncol=legend_ncol, prop=legend_prop)  ##
    axs.set_xlabel(vary_szs_x_label(num_of_server, tx, rp), fontsize=fontsize)
    plt.xscale('log')
    plt.xticks(sizes, tuple(sizes))
    plt.minorticks_off()
    plt.ylim(0, 5000)

    axs.set_ylabel("throughput (ops/sec)", fontsize=fontsize)
    plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
    plt.tight_layout()
    plt.savefig(f"LAN_{fig_num}_throughput,_vary_size,_{num_of_server}_svrs")
    plt.show()


def plot_throughput_vary_rp(exp_idxs, labels, tx, size, rps, num_of_server, fig_num):
    assert len(exp_idxs) == len(labels)
    alo_lists = [get_throughput_vary_rp(idx, tx, size, rps) for idx in exp_idxs]

    fig, axs = plt.subplots(figsize=fig_size)

    wps = [(10 - rp) / 10 for rp in rps][::-1]

    for j, alo_list in enumerate(alo_lists):
        axs.plot(wps, alo_list[::-1], colors[j], marker=markers[j], label=labels[j],
                 linestyle=linestyle, linewidth=linewidth, markersize=markersize)

    axs.legend(loc='upper left', ncol=legend_ncol, prop=legend_prop)  ##
    axs.set_xlabel(vary_rps_x_label(num_of_server, tx, size), fontsize=fontsize)
    axs.set_xticks(wps)
    plt.ylim(0, 5000)

    axs.set_ylabel("throughput (ops/sec)", fontsize=fontsize)
    plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
    plt.tight_layout()
    plt.savefig(f"LAN_{fig_num}_throughput,_vary_write,_{num_of_server}_svrs")
    plt.show()


#
# def plot_latency_vary_thread(exp_idxs, labels, txs, size, rp, num_of_server, tag, fig_num):
#     assert len(exp_idxs) == len(labels)
#     alo_lists = [get_latency_vary_thread(idx, txs, size, rp, tag) for idx in exp_idxs]
#
#     fig, axs = plt.subplots(figsize=fig_size)
#
#     for j, alo_list in enumerate(alo_lists):
#         axs.plot(txs, alo_list, colors[j], marker=markers[j], label=labels[j],
#                  linestyle=linestyle, linewidth=linewidth, markersize=markersize)
#
#     axs.legend(loc='upper left', ncol=legend_ncol, prop=legend_prop)  ##
#     axs.set_xlabel(vary_txs_x_label(num_of_server, size, rp), fontsize=fontsize)
#
#     plt.yticks(np.arange(0, 6500, step=500))
#     # plt.yticks(np.arange(0, 4500, step=500))
#
#     axs.set_ylabel(f"{tag} latency (µs)", fontsize=fontsize)
#     plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
#     plt.tight_layout()
#     plt.savefig(f"LAN {fig_num} latency, vary thread, {num_of_server} svrs, {tag}")
#     plt.show()


def plot_latency_vary_size(exp_idxs, labels, tx, sizes, rp, num_of_server, tag, fig_num):
    assert len(exp_idxs) == len(labels)
    alo_lists = [get_latency_vary_size(idx, tx, sizes, rp, tag) for idx in exp_idxs]

    fig, axs = plt.subplots(figsize=fig_size)

    for j, alo_list in enumerate(alo_lists):
        axs.plot(sizes, alo_list, colors[j], marker=markers[j], label=labels[j],
                 linestyle=linestyle, linewidth=linewidth, markersize=markersize)

    axs.legend(loc='upper left', ncol=legend_ncol, prop=legend_prop)  ##
    axs.set_xlabel(vary_szs_x_label(num_of_server, tx, rp), fontsize=fontsize)
    plt.xscale('log')
    plt.xticks(sizes, tuple(sizes))
    plt.minorticks_off()
    plt.yticks(np.arange(0, 3000, step=500))
    # plt.yticks(np.arange(0, 4500, step=500))
    # plt.yticks(np.arange(0, 6500, step=500))
    tag = ' '.join(tag.split("_"))
    axs.set_ylabel(f"{tag} latency (µs)", fontsize=fontsize)

    plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
    plt.tight_layout()
    tag = '_'.join(tag.split(" "))
    plt.savefig(f"LAN_{fig_num}_latency,_vary_size,_{num_of_server}_svrs,_{tag}")
    plt.show()


def plot_latency_vary_rp(exp_idxs, labels, tx, size, rps, num_of_server, tag, fig_num):
    assert len(exp_idxs) == len(labels)
    alo_lists = [get_latency_vary_rp(idx, tx, size, rps, tag) for idx in exp_idxs]

    fig, axs = plt.subplots(figsize=fig_size)

    wps = [(10 - rp) / 10 for rp in rps][::-1]

    for j, alo_list in enumerate(alo_lists):
        axs.plot(wps, alo_list[::-1], colors[j], marker=markers[j], label=labels[j],
                 linestyle=linestyle, linewidth=linewidth, markersize=markersize)

    axs.legend(loc='upper left', ncol=legend_ncol, prop=legend_prop)  ##
    axs.set_xlabel(vary_rps_x_label(num_of_server, tx, size), fontsize=fontsize)
    axs.set_xticks(wps)
    plt.yticks(np.arange(0, 3000, step=500))
    # plt.yticks(np.arange(0, 4500, step=500))

    tag = ' '.join(tag.split("_"))
    axs.set_ylabel(f"{tag} latency (µs)", fontsize=fontsize)
    plt.grid(color='tab:gray', linestyle=':', linewidth=0.8)
    plt.tight_layout()
    tag = '_'.join(tag.split(" "))
    plt.savefig(f"LAN_{fig_num}_latency,_vary_write,_{num_of_server}_svrs,_{tag}")
    plt.show()


if __name__ == '__main__':
    pass

    index_list_5 = [872, 892, 881, 981]
    # index_list_5 = [941, 951]
    names_list_5 = ['Cass-All', 'Cass-Quorum', 'Treas', 'Oreas']
    # names_list_5 = ['Cass-All', 'Treas-Opt']
    # vary_size_list = [2048, 4096]
    vary_size_list = [16, 64, 256, 1024, 2048, 4096]
    vary_rpx_list = [1, 5, 9]
    plot_throughput_vary_size(index_list_5, names_list_5, 1, vary_size_list, 9, 5, 11)
    plot_latency_vary_size(index_list_5, names_list_5, 1, vary_size_list, 9, 5, "average_read", 12)
    plot_latency_vary_size(index_list_5, names_list_5, 1, vary_size_list, 9, 5, "95_percentile_read", 13)
    plot_latency_vary_size(index_list_5, names_list_5, 1, vary_size_list, 9, 5, "average_write", 14)
    plot_latency_vary_size(index_list_5, names_list_5, 1, vary_size_list, 9, 5, "95_percentile_write", 15)
    #
    plot_throughput_vary_rp(index_list_5, names_list_5, 1, 128, vary_rpx_list, 5, 6)
    plot_latency_vary_rp(index_list_5, names_list_5, 1, 128, vary_rpx_list, 5, "average_read", 7)
    plot_latency_vary_rp(index_list_5, names_list_5, 1, 128, vary_rpx_list, 5, "95_percentile_read", 8)
    plot_latency_vary_rp(index_list_5, names_list_5, 1, 128, vary_rpx_list, 5, "average_write", 9)
    plot_latency_vary_rp(index_list_5, names_list_5, 1, 128, vary_rpx_list, 5, "95_percentile_write", 10)

    # def getTag():
    #     print("2KB ", end='')
    #     yield
    #     print("4KB ", end='')
    #     yield

    # list_4 = [872, 941, 881, 951]
    # name_4 = ["Cass-All-1", "Cass-All-2", 'Treas-Opt-1', 'Treas-Opt-3']
    # print(name_4)
    #
    # print("throughput")
    # t = getTag()
    # alo_lists = [get_throughput_vary_size(idx, 1, vary_size_list, 9) for idx in list_4]
    # alo_lists = [*zip(*alo_lists)]
    # for alo in alo_lists:
    #     next(t)
    #     print(alo)
    #
    # print("average_read")
    # t = getTag()
    # alo_lists = [get_latency_vary_size(idx, 1, vary_size_list, 9, "average_read") for idx in list_4]
    # alo_lists = [*zip(*alo_lists)]
    # for alo in alo_lists:
    #     next(t)
    #     print(alo)
    #
    # print("95_percentile_read")
    # t = getTag()
    # alo_lists = [get_latency_vary_size(idx, 1, vary_size_list, 9, "95_percentile_read") for idx in list_4]
    # alo_lists = [*zip(*alo_lists)]
    # for alo in alo_lists:
    #     next(t)
    #     print(alo)
    #
    # print("average_write")
    # t = getTag()
    # alo_lists = [get_latency_vary_size(idx, 1, vary_size_list, 9, "average_write") for idx in list_4]
    # alo_lists = [*zip(*alo_lists)]
    # for alo in alo_lists:
    #     next(t)
    #     print(alo)
    #
    # print("95_percentile_write")
    # t = getTag()
    # alo_lists = [get_latency_vary_size(idx, 1, vary_size_list, 9, "95_percentile_write") for idx in list_4]
    # alo_lists = [*zip(*alo_lists)]
    # for alo in alo_lists:
    #     next(t)
    #     print(alo)


