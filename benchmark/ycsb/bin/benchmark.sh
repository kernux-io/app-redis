#!/usr/bin/bash


## Define default values
export MODE="unikernel"
export HOSTID=20
export PORT=6379
export DIRECTORY="/home/kernux/Documents/thesis/app-redis/benchmark/ycsb"
export OUTPUT="default"
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
  for i in $(seq $COUNT); do
    i=$(($HOSTID+$i-1))
    
    $DIRECTORY/bin/ycsb.sh \
      run redis -s \
      -P $DIRECTORY/workloads/thesis \
      -p redis.host=192.168.1.$i \
      -p redis.port=$PORT \
      > $DIRECTORY/results/$OUTPUT/unikernel_$i.txt \
      &
  done
}

docker()
{
  for i in $(seq $COUNT); do
    i=$(($PORT+$i-1))
    
    $DIRECTORY/bin/ycsb.sh \
      run redis -s \
      -P $DIRECTORY/workloads/thesis \
      -p redis.host=192.168.1.$HOSTID \
      -p redis.port=$i \
      > $DIRECTORY/results/$OUTPUT/docker_$i.txt \
      &
  done
}

if [ $MODE = "unikernel" ]; then
  unikernel
else
  docker
fi
