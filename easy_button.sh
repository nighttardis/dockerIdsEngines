#!/bin/bash

while [[ $# > 0 ]]
do
key="$1"

case $key in
    --install-docker)
    INSTALL_DOCKER="YES"
    shift
    ;;
    --docker-snort-2.9.6.0)
    DOCKER-SNORT-2.9.6.0="YES"
    shift
    ;;
    --docker-snort-2.9.7.2)
    DOCKER_SNORT_2.9.7.2="YES"
    shift
    ;;
    --docker-snort-2.9.7.2_openappid)
    DOCKER_SNORT_2.9.7.2_OPENAPPID="YES"
    shift
    ;;
    --install-all)
    INSTALL_ALL_IMAGES="YES"
    INSTALL_DOCKER="YES"
    shift
    ;;
    --install-images)
    INSTALL_ALL_IMAGES="YES"
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
if [ "$DOCKER-SNORT-2.9.6.0" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.6.0"
    docker pull decodedtechsolutions/docker-snort-2.9.6.0
    docker tag decodedtechsolutions/docker-snort-2.9.6.0 snort-2.9.6.0
    docker rmi decodedtechsolutions/docker-snort-2.9.6.0
fi

# get docker-snort-2.9.7.2
if [ "$DOCKER_SNORT_2.9.7.2" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.7.2"
    docker pull decodedtechsolutions/docker-snort-2.9.7.2
    docker tag decodedtechsolutions/docker-snort-2.9.7.2 snort-2.9.7.2
    docker rmi decodedtechsolutions/docker-snort-2.9.7.2
fi

# get docker-snort-2.9.7.2_openappid
if [ "$DOCKER_SNORT_2.9.7.2_OPENAPPID" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.7.2_openappid"
    docker pull decodedtechsolutions/docker-snort-2.9.7.2-openappid
    docker tag decodedtechsolutions/docker-snort-2.9.7.2-openappid snort-2.9.7.2_openappid
    docker rmi decodedtechsolutions/docker-snort-2.9.7.2-openappid
fi

./update_ruleset.sh
