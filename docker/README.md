# Docker

## Settings

### Overcommit Memory

```sh
WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
```

Add the following to the file: `/etc/sysctl.conf`:

```sh
vm.overcommit_memory = 1
```

Reboot the machine and run:

```sh
sudo sysctl vm.overcommit_memory=1
```

## Launch the Redis Container

### Running a Single Container
```sh
docker-compose up
```

### Running Multiple Containers

```sh
docker-compose up --scale redis=2
```

## Test the Application

```sh
telnet 172.28.1.4 6379
```

## Error-Handling

If the container(s) is/are no longer accessible remotely after restarting the docker containers, restart the machine.
