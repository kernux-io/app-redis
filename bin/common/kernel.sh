#!/usr/bin/bash

## Define the unikernel artifact to use
path_artifacts="/home/kernux/Documents/thesis/app-redis/artifacts"
artifact="redis_kvm-x86_64"
type="_base"
kernel="${path_artifacts}/${artifact}${type}"
