# Unikernel

## Prerequisites

### Install Requirements

```sh
apt-get install -y --no-install-recommends \
    build-essential \
    libncurses-dev \
    libyaml-dev \
    flex \
    git \
    wget \
    socat \
    bison \
    unzip \
    uuid-runtime \
    python3 \
    python3-setuptools
```

### Install `kraft`

```python3
pip3 install git+https://github.com/unikraft/kraft.git@staging
```

### Expose the `kraft` CLI Tool

Add the following to the `~/.bashrc` file: 

```sh
export PATH=".local/bin:$PATH"
```

You can now use the `kraft` CLI tool from the terminal:

```sh
$ kraft
Usage: kraft [OPTIONS] COMMAND [ARGS]...

Options:
  --version         Show the version and exit.
  -C, --no-color    Do not use colour in output logs.
  -T, --timestamps  Show timestamps in output logs.
  -Y, --yes         Assume yes to any binary prompts.
  -v, --verbose     Enables verbose mode.
  -h, --help        Show this message and exit.

Commands:
  build       Build the application.
  clean       Clean the application.
  configure   Configure the application.
  fetch       Fetch library dependencies.
  init        Initialize a new unikraft application.
  lib         Unikraft library commands.
  list        List architectures, platforms, libraries or applications.
  menuconfig  Open the KConfig Menu editor
  prepare     Runs preparations steps on libraries.
  run         Run the application.
  up          Configure, build and run an application.

Influential Environmental Variables:
  UK_WORKDIR The working directory for all Unikraft
             source code [default: ~/.unikraft]
  UK_ROOT    The directory for Unikraft's core source
             code [default: $UK_WORKDIR/unikraft]
  UK_LIBS    The directory of all the external Unikraft
             libraries [default: $UK_WORKDIR/libs]
  UK_APPS    The directory of all the template applications
             [default: $UK_WORKDIR/apps]
  KRAFTRC  The location of kraft's preferences file
             [default: ~/.kraftrc]

Help:
  For help using this tool, please open an issue on Github:
  https://github.com/unikraft/kraft
```

### Generate Github Personal Access Token

In order to use the `kraft` tool, it is necessary to generate a [personal access token from Github](https://github.com/settings/tokens) with the following scope: `repo:public_repo`.

After it is generate, add the token value to the `~/.bashrc` file:

```sh
export UK_KRAFT_GITHUB_TOKEN=<token value>
```

You can now update the `kraft` mappings by first setting the working directory and then running the list update command:

```sh
export UK_WORKDIR=$pwd/unikernel
kraft list update
```


## Running a `helloworld` Application

It is now possible to test that everything is working as we expect by launching the `helloworld` application with the following command:

```sh
$ kraft up -p kvm -m x86_64 -t helloworld helloworld
...
Booting from ROM...
Powered by
o.   .o       _ _               __ _
Oo   Oo  ___ (_) | __ __  __ _ ' _) :_
oO   oO ' _ `| | |/ /  _)' _` | |_|  _)
oOo oOO| | | | |   (| | | (_) |  _) :_
 OoOoO ._, ._:_:_,\_._,  .__,_:_, \___)
                   Tethys 0.5.0~b8be82b
Hello world!
Arguments:  "/home/kernux/Documents/thesis/app-redis/unikernel/apps/helloworld/build/helloworld_kvm-x86_64" "console=ttyS0"
Console terminated, terminating guest (PID: 7494)...
```


## Running a `redis` Application

```sh
kraft init -t redis $UK_WORKDIR/apps/app-redis
cd $UK_WORKDIR/libs/lwip && git checkout stable
cd $UK_WORKDIR/libs/newlib && git checkout stable
cd $UK_WORKDIR/libs/pthread-embedded && git checkout stable
cd $UK_WORKDIR/libs/redis && git checkout stable
cd $UK_WORKDIR/unikraft && git checkout stable
```

```sh
/home/kernux/.local/bin/qemu-guest \
    -k /home/kernux/Documents/thesis/app-redis/artifacts/redis_kvm-x86_64_base \
    -a "netdev.ipv4_addr=192.168.1.20 netdev.ipv4_gw_addr=192.168.1.1 netdev.ipv4_subnet_mask=255.255.255.0 -- /redis.conf" \
    -b br0 \
    -e /home/kernux/Documents/thesis/app-redis/config \
    -m 500
```

```sh
sudo iptables -I FORWARD -i br0 -o br0 -j ACCEPT
```

## Test the Application

```sh
telnet 192.168.1.20 6379
```
