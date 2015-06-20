#!/bin/bash

# TODO - show list of available images for useage
# TODO - argument validate
#        image is present

HELP="NO"
if [ $# -eq 0 ]; then
        HELP="YES"
fi

#for key in "$@"
while [[ $# > 0 ]]
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
    if [ ! -f "$(pwd)"/pcaps/"$PCAP" ] ; then
        echo "PCAP FILE NOT FOUND"
        echo "./pcaps/"$PCAP" does not exist"
        exit 1
    fi
    shift
    ;;
    -x|--extra)
    EXTRAS="$2"
    shift
    ;;
    -h|--help)
    HELP="YES"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift
done
#exit
# ensure engine is set and a supported engined options are there
if [ -z "$ENGINE" ] ; then
    HELP="YES"
    echo "-e|--engine flag missing"
fi

if [ "$ENGINE" != "snort" ] && [ "$ENGINE" != "suricata" ] ; then
    echo "$ENGINE is not currently supported"
    HELP="YES"
fi

# ensure ruleset is set and is there
if [ -z "$RULESET" ] ; then
    HELP="YES"
    echo "-r|--ruleset flag missing"
fi

if [ ! -d ./policies/"$ENGINE"/"$RULESET" ] ; then
    echo "RULESET NOT FOUND"
    echo "Ruleset Directory ./policies/"$ENGINE"/"$RULESET" does not exist"
    exit 1
fi

if [[ "$HELP" = "YES" ]] ; then
echo "Usage: $0 -i [image_name] -e [engine] -r [ruleset] -p [pcap] -x [extra options]";
echo "";
echo "-i|--image        image name to use";
echo "-e|--engine       IDS engine to run (currently snort or suricata)";
echo "-r|--ruleset      ruleset name to for which to load the config file";
echo "-p|--pcap packet capture file to read";
echo "-x|--extra        any other options to the IDS engine you'd like ('-k none')";
echo "-h|--help display this helpful information";
echo "";
echo "Everything but -x is required";
echo "";
exit 1;
fi

LOGDIR=$(date +%Y%m%d-%H%M%S)

if [ "$ENGINE" = "snort" ]; then
    docker run --rm -v "$(pwd)"/policies/"$ENGINE"/"$RULESET":/usr/local/etc/"$ENGINE" -v "$(pwd)"/pcaps/:/tmp/ -v "$(pwd)"/logs/"$ENGINE"/"$LOGDIR"_"$PCAP":/var/log/"$ENGINE"/ "$IMAGE" "$ENGINE" -c /usr/local/etc/"$ENGINE"/snort.conf -r /tmp/"$PCAP" -H -A console $EXTRAS
elif [ "$ENGINE" = "suricata" ];  then
	docker run --rm -v "$(pwd)"/policies/"$ENGINE"/"$RULESET":/usr/local/etc/"$ENGINE" -v "$(pwd)"/pcaps/:/tmp/ -v "$(pwd)"/logs/"$ENGINE"/"$LOGDIR"_"$PCAP":/var/log/"$ENGINE"/ "$IMAGE" "$ENGINE" -c /usr/local/etc/"$ENGINE"/suricata.yaml -r /tmp/"$PCAP" $EXTRAS
fi
