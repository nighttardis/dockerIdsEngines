#!/bin/bash

for key in "$@"
do
case $key in
    --install-docker)
    INSTALL_DOCKER="YES"
    shift
    ;;
    --docker-snort-2.9.6.0)
    DOCKER_SNORT_2_9_6_0="YES"
    shift
    ;;
    --docker-snort-2.9.7.2)
    DOCKER_SNORT_2_9_7_2="YES"
    shift
    ;;
    --docker-snort-2.9.7.2-openappid)
    DOCKER_SNORT_2_9_7_2_OPENAPPID="YES"
    shift
    ;;
	--docker-suricata-2.0.8)
	DOCKER_SURICATA_2_0_8="YES"
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
    --proxy-setup)
    SETUP_PROXY="YES"
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

if [ "$SETUP_PROXY" = "YES" ]; then
	echo "Proxy Setup Initiated"
	echo "This will add the proxy to the docker config at /etc/default/docker"
	
	echo "Enter address as proxy.address.com:<port>"
	read -p "Proxy Address: " PROXY_ADDRESS
	read -p "Proxy Username: " PROXY_USERNAME
    while true
    do
	    echo "Enter Proxy Password - be sure to URL encode any special characters"
        read -sp "Proxy Password: " PROXY_PASSWORD_1; echo
		read -sp "Confirm Proxy Password: " PROXY_PASSWORD_2; echo
		[ "$PROXY_PASSWORD_1" = "$PROXY_PASSWORD_2" ] && break
        echo "Passwords do not match. Please try again"
    done
    
	# export the proxy here so the install-docker and update_rulset.sh will work.
	export http_proxy=http://$PROXY_USERNAME:$PROXY_PASSWORD_1@$PROXY_ADDRESS
	export https_proxy=http://$PROXY_USERNAME:$PROXY_PASSWORD_1@$PROXY_ADDRESS

fi


# set UTC timestamp
# mv /etc/localtime /etc/localtime.bak
# ln -s /usr/share/zoneinfo/UTC /etc/localtime

# install docker
if [ "$INSTALL_DOCKER" = "YES" ]; then
	echo "Installing docker"
	wget -qO- https://get.docker.com/ | sh
	usermod -aG docker "$(who | awk '{print $1}')"
fi


if [ "$SETUP_PROXY" = "YES" ]; then
	echo "export http_proxy=\"http://$PROXY_USERNAME:$PROXY_PASSWORD_1@$PROXY_ADDRESS\"" >> /etc/default/docker
	echo "restarting docker to make proxy change take effect"
	service docker restart
fi

# get docker-snort-2.9.6.0
if [ "$DOCKER_SNORT_2_9_6_0" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.6.0"
    docker pull decodedtechsolutions/docker-snort-2.9.6.0

fi

# get docker-snort-2.9.7.2
if [ "$DOCKER_SNORT_2_9_7_2" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.7.2"
    docker pull decodedtechsolutions/docker-snort-2.9.7.2

fi

# get docker-snort-2.9.7.2_openappid
if [ "$DOCKER_SNORT_2_9_7_2_OPENAPPID" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-snort-2.9.7.2_openappid"
    docker pull decodedtechsolutions/docker-snort-2.9.7.2-openappid

fi

if [ "$DOCKER_SURICATA_2_0_8" = "YES" ] || [ "$INSTALL_ALL_IMAGES" = "YES" ]; then
	echo "pulling docker-suricata-2.0.8"
    docker pull decodedtechsolutions/docker-suricata-2.0.8
fi

./update_ruleset.sh
