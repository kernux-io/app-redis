# App: Redis

This repository contains everything related to the Redis applications constructed for the thesis experiments.

## Folder Structure

```
.
├── artifacts
│     ├── redis_kvm-x86_64_base
│     ├── redis_kvm-x86_64_dce
│     └── redis_kvm-x86_64_dce-allocpool
├── benchmark
│     ├── ycsb
│     │     ├── bin
│     │     │     ├── benchmark.sh
│     │     │     ├── bindings.properties
│     │     │     ├── redis-cli
│     │     │     ├── ycsb
│     │     │     ├── ycsb.bat
│     │     │     └── ycsb.sh
│     │     ├── lib
│     │     │     ├── commons-pool2-2.4.2.jar
│     │     │     ├── core-0.17.0.jar
│     │     │     ├── HdrHistogram-2.1.4.jar
│     │     │     ├── htrace-core4-4.1.0-incubating.jar
│     │     │     ├── jackson-core-asl-1.9.4.jar
│     │     │     ├── jackson-mapper-asl-1.9.4.jar
│     │     │     ├── jedis-2.9.0.jar
│     │     │     └── redis-binding-0.17.0.jar
│     │     ├── results
│     │     │     ├── tmp
│     │     │     └── ...
│     │     ├── workloads
│     │     │     ├── thesis
│     │     │     ├── tsworkload_template
│     │     │     ├── tsworkloada
│     │     │     ├── workload_template
│     │     │     ├── workloada
│     │     │     ├── workloadb
│     │     │     ├── workloadc
│     │     │     ├── workloadd
│     │     │     ├── workloade
│     │     │     └── workloadf
│     │     ├── LICENSE.txt
│     │     ├── NOTICE.txt
│     │     └── README.md
├── bin
│     ├── start.sh
│     └── stop.sh
├── config
│     └── redis.conf
├── docker
│     ├── docker-compose.yml
│     └── README.md
├── unikernel
│     ├── apps
│     ├── archs
│     ├── libs
│     ├── plats
│     ├── unikraft
│     └── README.md
├── .gitignore
└── README.md
```
