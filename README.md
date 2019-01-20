docker-keepassxc
---

# Introduction

The repository provides a script and Docker image to run
[KeePassXC](https://keepassxc.org) on Linux.

# Installation

To build the image yourself run command:

```
docker build -t jakubstefanski/keepassxc:latest image
```

You can download a [wrapper
script](https://github.com/jakubstefanski/docker-keepassxc/blob/master/docker-keepassxc)
that is useful for starting KeePassXC in a container. It prepares correct
`docker run` parameters for the image.

```
sudo wget https://raw.githubusercontent.com/jakubstefanski/docker-keepassxc/master/docker-keepassxc -O /usr/local/bin/docker-keepassxc
sudo chmod +x /usr/local/bin/docker-keepassxc
```

# Usage

The simplest case is to run KeePassXC just as it would be installed locally:
```
docker-keepassxc
```

You can also pass CLI parameters:
```
docker-keepassxc --keyfile ~/example.key ~/example.kdbx
```

To isolate the container from your home directory you can override HOME
environment variable (must be absolute path):
```
HOME=~/keepass-home docker-keepassxc
```

To see what options are passed to `docker run` set verbose to true:
```
DKEEPASSXC_VERBOSE=true docker-keepassxc
```

You can also override `docker run` options:
```
DKEEPASSXC_OPTS='--interactive' docker-keepassxc
```

Or run custom `keepassxc-cli` command:
```
DKEEPASSXC_CMD='keepassxc-cli' DKEEPASSXC_OPTS='-it --rm' docker-keepassxc diceware
```

An advanced example is passing password by stdin:
```
container=$(DKEEPASSXC_OPTS='-it --rm' docker-keepassxc --pw-stdin --keyfile ~/example.key ~/example.kdbx)
cat secret.txt | docker attach --sig-proxy=false "${container}" &
kill $!
```
