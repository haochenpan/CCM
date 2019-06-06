files = ['data/vnstat/quo.m.txt', 'data/vnstat/all.m.txt',
         'data/vnstat/abd.m.txt', 'data/vnstat/opt.m.txt',
         'data/vnstat/dsk.m.txt']


def read_file(fname):
    tx, rx, rate, cnt = 0, 0, 0, 0
    with open(fname, 'r') as f:
        lines = f.readlines()
    unit = None
    for line in lines:
        if 'Mbit/s' in line or 'kbit/s' in line:
            line = line.split()
            unit = line[12]

            tx += float(line[2])
            rx += float(line[5])
            rate += float(line[11])
            cnt += 1

            # print(line)
    # print(f'{fname}, cnt:{cnt}, tx-sum:{round(tx, 2)}, rx-sum:{round(rx, 2)}, total-sum:{round(tx + rx, 2)}, rate-sum:{round(rate, 2)}, unit:{unit}')
    print(f'{fname.split(".")[0]}, cnt:{cnt} instances, for each: tx-avg:{round(tx / cnt, 2)} GiB, rx-avg:{round(rx / cnt, 2)} GiB, '
          f'total-avg:{round((tx + rx) / cnt, 2)} GiB, rate-avg:{round(rate / cnt, 2)} {unit}')


if __name__ == '__main__':
    for f in files:
        read_file(f)
