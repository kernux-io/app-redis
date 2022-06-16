#!/usr/bin/bash


## Import external config
source /home/kernux/Documents/thesis/app-redis/bin/common/cpus.sh
source /home/kernux/Documents/thesis/app-redis/bin/common/kernel.sh
source /home/kernux/Documents/thesis/app-redis/bin/common/network.sh

## Define constants
declare -r MAXIMUM_COUNT=65536

## Define default values
export COUNT=1
export MEMORY=200

## Process input arguments
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - spin up wanted number of Redis unikernels"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-c, --count=COUNT         specify the number of Redis unikernels to create (1 - 65535)"
      exit 0
      ;;
    -c)
      shift
      if test $# -gt 0; then
        if [[ $1 -le $MAXIMUM_COUNT && $1 =~ ^[0-9]+$ ]]; then
          export COUNT=$1
        else
          echo "Please specify an integer value (between 1 - 65535) for the number of Redis unikernels to create."
          exit 1
        fi
      fi
      shift
      ;;
    --count*)
      if [[ $2 -le $MAXIMUM_COUNT && $2 =~ ^[0-9]+$ ]]; then
        export COUNT=$2
      else
        echo "Please specify an integer value (between 1 - 65535) for the number of Redis unikernels to create."
        exit 1
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done

echo "" > "/home/kernux/Documents/thesis/app-redis/benchmark/ycsb/results/logs/${COUNT}i_${MEMORY}m_3x100r/${COUNT}i_${MEMORY}m${type}.txt"

## Create new network bridges
for i in $(seq $COUNT); do
  i=$((50+$i-1))
  
  /home/kernux/.local/bin/qemu-guest \
    -k $kernel \
    -a "netdev.ipv4_addr=$netId1.$netId2.$netId3.$i netdev.ipv4_gw_addr=$netId1.$netId2.$netId3.$hostId netdev.ipv4_subnet_mask=255.255.255.0 -- /redis.conf" \
    -b br0 \
    -e /home/kernux/Documents/thesis/app-redis/config \
    -m $MEMORY \
    -x >> "/home/kernux/Documents/thesis/app-redis/benchmark/ycsb/results/logs/${COUNT}i_${MEMORY}m_3x100r/${COUNT}i_${MEMORY}m${type}.txt"

  sleep 1
done

## Make sure br0 is forwarded
sudo iptables -I FORWARD -i br0 -o br0 -j ACCEPT

# Await stable state
sleep 30

## Test connections
running_apps=0
for i in $(seq $COUNT); do
  i=$((50+$i-1))

  res=$(/home/kernux/Documents/thesis/app-redis/benchmark/ycsb/bin/redis-cli \
    -h $netId1.$netId2.$netId3.$i \
    -p 6379 \
    ping)

  if [ $res = "PONG" ]
  then
    ((running_apps++))
  fi
done

echo "Number of started Redis instances: $running_apps / $COUNT"
