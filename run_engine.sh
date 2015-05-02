#!/bin/bash

# TODO - show list of available images for useage
# TODO - argument validate
#	 all required options are there
#	 image, ruleset and pcap exists

 
if [ $# -eq 0 ]; then
echo "Usage: $0 -i [image_name] -e [engine] -r [ruleset] -p [pcap] -x [extra options]";
echo "";
echo "[image_name] = the docker image name to run";
echo "[engine] = the IDS engine to run (currently snort or suricata)";
echo "[ruleset] = The ruleset name to for which to load the config file";
echo "[pcap] = the packet capture file to read";
echo "[extra options] = any other options to the IDS engine you'd like ("-k none")";
echo " Everything but -x is required";
echo "";
exit 1;
fi


while [[ $# > 1 ]]
do
key="$1"

case $key in
    -i|--image)
    IMAGE="$2"
    shift
    ;;
    -e|--engine)
    ENGINE="$2"
    shift
    ;;
    -r|--ruleset)
    RULESET="$2"
    shift
    ;;
    -p|--pcap)
    PCAP="$2"
    shift
    ;;
    -x|--extra)
    EXTRAS="$2"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift
done


if [ "$ENGINE" = "snort" ]; then 
        docker run --rm -v /usr/local/etc/dockerIdsEngines/"$ENGINE"/"$RULESET":/usr/local/etc/"$ENGINE"/"$RULESET" -v /usr/local/etc/dockerIdsEngines/pcaps/:/tmp/ "$IMAGE" "$ENGINE" -c /usr/local/etc/snort/"$RULESET"/snort.conf -N -r /tmp/"$PCAP" -H -A console "$EXTRAS" 
elif [ "$ENGINE" = "suricata" ];  then 
        echo 'run suricata'
fi

