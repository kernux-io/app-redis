#!/usr/bin/bash

source /home/kernux/Documents/thesis/app-redis/bin/common/kernel.sh

output="/home/kernux/Documents/thesis/app-redis/benchmark/ycsb/results/logs/20i_400m_100r/unikernel$type.txt"
originalIFS=$IFS

pids=$(pidof /usr/bin/qemu-system-x86_64)
echo $pids

logpid() {
    while sleep 1; do
        date +%H:%M:%S >> $output
        IFS=',' ;ps -p $pids -o pid,%cpu,%mem >> $output
    done;
}

logpid
