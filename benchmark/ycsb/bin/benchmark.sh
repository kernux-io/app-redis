#!/bin/bash

# Artifacts
A1="allocpool"
A2="base"
A3="dce"
A4="dce-allocpool"
A5="falloc"
A6="fbuddyalloc"

## Define default values
export MODE="unikernel"
export HOSTID=50
export PORT=6379
export DIRECTORY="/Users/t943167/Documents/private/thesis/app-redis/benchmark/ycsb"
export OUTPUT="20i_400m_3x100r/unikernel_$A6"
export SET=3
export ROUNDS=100
export COUNT=1

## Process input arguments
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - trigger YCSB benchmarking for Redis"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help    show brief help"
      echo "-m            define mode - unikernel or docker"
      echo "-i            define host id"
      echo "-p            define port"
      echo "-d            define the YCSB directory path"
      echo "-o            define the sub-directory under results where outputs files are placed"
      echo "-r            define the number of times each Redis instance should execute a benchmark"
      echo "-c            specify the number of Redis applications running"
      exit 0
      ;;
    -m)
      shift
      if test $# -gt 0; then
        export MODE=$1
      fi
      shift
      ;;
    -i)
      shift
      if test $# -gt 0; then
        export HOSTID=$1
      fi
      shift
      ;;
    -p)
      shift
      if test $# -gt 0; then
        export PORT=$1
      fi
      shift
      ;;
    -d)
      shift
      if test $# -gt 0; then
        export DIRECTORY=$1
      fi
      shift
      ;;
    -o)
      shift
      if test $# -gt 0; then
        export OUTPUT=$1
      fi
      shift
      ;;
    -r)
      shift
      if test $# -gt 0; then
        export ROUNDS=$1
      fi
      shift
      ;;
    -c)
      shift
      if test $# -gt 0; then
        if [[ $2 -le $MAXIMUM_COUNT && $1 =~ ^[0-9]+$ ]]; then
          export COUNT=$1
        else
          echo "Please specify an integer value (between 1 - 65535) for the number of Redis unikernels to create."
          exit 1
        fi
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done

unikernel()
{
  echo "Unikernel run starting..."
  for s in $(seq $SET); do
    for r in $(seq $ROUNDS); do
      for i in $(seq $COUNT); do
        i=$(($HOSTID+$i-1))
        
        $DIRECTORY/bin/ycsb.sh \
          run redis -s \
          -P $DIRECTORY/workloads/thesis \
          -p redis.host=192.168.1.$i \
          -p redis.port=$PORT \
          > $DIRECTORY/results/$OUTPUT/unikernel_${i}i_s${s}_${r}r.txt \
          &
      done
    done
    wait $(jobs -p)
  done
}

docker()
{
  echo "Docker run starting..."
  for s in $(seq $SET); do
    for r in $(seq $ROUNDS); do
      for i in $(seq $COUNT); do
        i=$(($PORT+$i-1))
        
        $DIRECTORY/bin/ycsb.sh \
          run redis -s \
          -P $DIRECTORY/workloads/thesis \
          -p redis.host=192.168.1.$HOSTID \
          -p redis.port=$i \
          > $DIRECTORY/results/$OUTPUT/docker_${i}i_s${s}_${r}r.txt \
          &
      done
    done
    wait $(jobs -p)
  done
}

date +”%H:%M:%S” >> $DIRECTORY/results/$OUTPUT/start_stop.txt
if [ $MODE = "unikernel" ]; then
  unikernel
else
  docker
fi
date +”%H:%M:%S” >> $DIRECTORY/results/$OUTPUT/start_stop.txt
