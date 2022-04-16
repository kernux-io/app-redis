#!/usr/bin/bash


## Process input arguments
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - trigger YCSB benchmarking for Redis"
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