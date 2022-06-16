#!/usr/bin/bash

A1="allocpool"
A2="base"
A3="dce"
A4="dce-allocpool"
A5="falloc"
A6="fbuddyalloc"

## Define the unikernel artifact to use
path_artifacts="/home/kernux/Documents/thesis/app-redis/artifacts"
artifact="redis_kvm-x86_64"
type="_$A1"
kernel="${path_artifacts}/${artifact}${type}"
