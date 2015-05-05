#!/bin/bash

while [[ $# -ge 1 ]]
do

key="$1"

case $key in
    -i|--install-docker)
    INSTALL_DOCKER="YES"
	shift
    ;;
	*)
         echo "unknown"   # unknown option
    ;;
esac
shift
done
# check for root permissions
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

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
if [ "$INSTALL_DOCKER" = "YES" ]; then
	echo "Installing docker"
	wget -qO- https://get.docker.com/ | sh
	usermod -aG docker "$(id -un 2>/dev/null || true)"
fi
chown -R :docker /usr/local/etc/dockerIdsEngines

# get docker-snort-2.9.6.0
docker pull brandondecodedtechsolutions/docker-snort-2.9.6.0
docker tag brandondecodedtechsolutions/docker-snort-2.9.6.0 snort-2.9.6.0
docker rmi brandondecodedtechsolutions/docker-snort-2.9.6.0

./update_ruleset.sh
