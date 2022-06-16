#!/usr/bin/bash

source /home/kernux/Documents/thesis/app-redis/bin/common/kernel.sh

filename="unikernel$type"
#filename="docker"
output="/home/kernux/Documents/thesis/app-redis/benchmark/ycsb/results/logs/20i_400m_3x100r/$filename"

echo "" > "$output-ps.txt"
echo "" > "$output-vmstat.txt"
echo "" > "$output-slabtop.txt"
echo "" > "$output-free.txt"
if [ $filename = "docker" ]; then
    echo "" > "$output-stats.txt"
fi

logpid() {
    while sleep 1; do
        datetime=$(date +%H:%M:%S)
        echo $datetime
        
        echo $datetime >> "$output-ps.txt"
        if [ $filename = 'docker' ]; then
            ps aux | grep docker >> "$output-ps.txt"
        else
            ps aux | grep /qemu >> "$output-ps.txt"
        fi

        echo $datetime >> "$output-vmstat.txt"
        vmstat >> "$output-vmstat.txt"

        echo $datetime >> "$output-slabtop.txt"
        sudo slabtop -o >> "$output-slabtop.txt"

        echo $datetime >> "$output-free.txt"
        free >> "$output-free.txt"

        if [ $filename = "docker" ]; then
            echo $datetime >> "$output-stats.txt" \
            $(docker stats --no-stream) >> "$output-stats.txt" &
        fi
    done;
}

logpid
