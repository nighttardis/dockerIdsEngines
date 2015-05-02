#!/bin/bash



# make directory for storing common files that will be shared by snort 
# an example is going to the ruleset files
mkdir --parents /usr/local/etc/dockerIdsEngines/snort/
mkdir --parents /usr/local/etc/dockerIdsEngines/suricata

# make directory for storing pcaps that can be used among multiple containers
mkdir --parents /usr/local/etc/dockerIdsEngines/pcaps/

# set UTC timestamp
# mv /etc/localtime /etc/localtime.bak
# ln -s /usr/share/zoneinfo/UTC /etc/localtime

# install docker
wget -qO- https://get.docker.com/ | sh

usermod -aG docker "$(id -un 2>/dev/null || true)"

chown -R :docker /usr/local/etc/dockerIdsEngines


docker pull brandondecodedtechsolutions/docker-snort-2.9.6.0
