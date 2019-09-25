import os
import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict

DATA_FOLDER = "../data2/"


def get_files(algosize):
    band_files, mem_files = [], []
    algosize = os.path.join(algosize, "run")
    algosize = os.path.join(DATA_FOLDER, algosize)
    for root, dirs, files in os.walk(algosize):
        for file in files:
            if file.startswith("band"):
                band_files.append(os.path.join(root, file))
            elif file.startswith("mem"):
                mem_files.append(os.path.join(root, file))

    assert len(band_files) == 5, "5 servers"
    assert len(mem_files) == 5, "5 servers"
    return band_files, mem_files


def get_cpu_mem_info(file):
    assert "mem" in file
    cpu, mem = [], []
    with open(file, "r") as f:
        for line in f.readlines():
            if "java -Xloggc:" in line:
                arr = line.split()
                cpu.append(float(arr[4]))
                mem.append(float(arr[5]))
    cpu = round(sum(cpu) / len(cpu), 1)
    mem = round(sum(mem) / len(mem), 1)
    return cpu, mem


def get_band_info(file):
    assert "band" in file
    band_info = {}
    with open(file, "r") as f:
        for line in f.readlines():
            line = line.split()
            if "bytes" in line:
                if line[2] == 'MiB':
                    band_info["rx_total"] = float(line[1])
                elif line[2] == "GiB":
                    band_info["rx_total"] = float(line[1]) * 1024
                else:
                    raise Exception
                if line[5] == 'MiB':
                    band_info["tx_total"] = float(line[4])
                elif line[5] == "GiB":
                    band_info["tx_total"] = float(line[4]) * 1024
                else:
                    raise Exception

            if "average" in line:
                if line.count('Mbit/s') == 2:
                    band_info["rx_avg_per_sec"] = float(line[1])
                    band_info["tx_avg_per_sec"] = float(line[4])
            if "time" in line:
                assert line.count('minutes') == 1, ""
                band_info["duration"] = float(line[1])

    total_sum = band_info["rx_total"] + band_info["tx_total"]
    avg_sum = band_info["rx_avg_per_sec"] + band_info["tx_avg_per_sec"]
    band_info["rx_and_tx_total"] = total_sum
    band_info["rx_and_tx_avg_per_sec"] = avg_sum
    return band_info


if __name__ == '__main__':
    folder_names = ["cassall16", "cassall4096", "cassquorum16", "cassquorum4096",
                    "treas16", "treas4096", "oreas16", "oreas4096"]
    for folder in folder_names:
        report_raw = defaultdict(lambda: [])
        report = {}
        report["name"] = folder + "-per-server"

        band, mem = get_files(folder)
        for ban in band:
            band_info = get_band_info(ban)
            for k, v in band_info.items():
                report_raw[k].append(v)
        for me in mem:
            c, m = get_cpu_mem_info(me)
            report_raw["cpu_percent"].append(c)
            report_raw["mem_percent"].append(m)
        for k, v in report_raw.items():
            assert len(v) == 5, "5 servers"
            report[k] = round(sum(v) / len(v), 2)
        # print(*list(report.values()), sep='\t')
        print(*list(report.keys()), sep='\t')
