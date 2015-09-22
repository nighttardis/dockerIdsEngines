#!/usr/bin/python
#
# Desigened to be used with https://github.com/zoomequipd/dockerIdsEngines
# This is a more robust version of the run_engine.sh
# Defaults can be used for the engine, image as well as the Ruleset
#


import argparse, os, sys, time

# Default variables 
default_engine = "snort"
default_snort_image = "zoomequipd/docker-snort:latest"
default_suricata_image = "zoomequipd/docker-suricata:latest"
default_ruleset = "ETOpen"

# Main Function
def main():
    #Parse CLI Arguments
    parser = argparse.ArgumentParser(description='Run Docker IDS Engine in offline mode against a given PCAP file'
            ,formatter_class=argparse.RawTextHelpFormatter)
    requiredNamed = parser.add_argument_group('required arguments')
    parser.add_argument('-i','--image', help='Docker Image to use\nSnort Default: zoomequipd/docker-snort:2.9.7.2\n'
            'Suricata Default: zoomequipd/docker-suricata:2.0.8')
    parser.add_argument('-e','--engine', help='IDS Engine (Snort|Suricata) Default:Snort')
    parser.add_argument('-r','--ruleset', help='IDS Ruleset to use Default:ETOpen')
    requiredNamed.add_argument('-p','--pcap', help='PCAP file to replay', required=True)
    parser.add_argument('-x','--extra', help='Extra Values to pass to the IDS Engine', nargs=argparse.REMAINDER)

    args = parser.parse_args()

    if (not os.path.isdir("./policies/"+(args.engine or default_engine)+"/"+(args.ruleset or default_ruleset))):
        print "Ruleset was not found"
        print "Rulese: ./policies/"+(args.engine or default_engine)+"/"+(args.ruleset or default_ruleset)+" does not exist"
        sys.exit(1)

    LOGDIR=time.strftime("%Y%m%d-%H%M%S")
    cwd = os.getcwd()

    if ((args.engine or default_engine).lower() == "snort"):
        cmd="docker run --rm -v "+cwd+"/policies/"+(args.engine or default_engine)+"/"+(args.ruleset or default_ruleset)
        cmd+=":/usr/local/etc/"+(args.engine or default_engine)+" -v "+cwd+"/pcaps/:/tmp/ -v "+cwd+"/logs/"+(args.engine or default_engine)
        cmd+="/"+LOGDIR+"_"+args.pcap+":/var/log/"+(args.engine or default_engine)+"/ "+(args.image or default_snort_image)+" "
        cmd+=(args.engine or default_engine)+" -c /usr/local/etc/"+(args.engine or default_engine)+"/snort.conf -r /tmp/"+args.pcap+" -H "+(args.extra[0] or "")
        os.system(cmd)
    elif ((args.engine or default_engine).lower() == "suricata"):
        cmd="docker run --rm -v "+cwd+"/policies/"+(args.engine or default_engine)+"/"+(args.ruleset or default_ruleset)
        cmd+=":/usr/local/etc/"+(args.engine or default_engine)+" -v "+cwd+"/pcaps/:/tmp/ -v "+cwd+"/logs/"+(args.engine or default_engine)
        cmd+="/"+LOGDIR+"_"+args.pcap+":/var/log/"+(args.engine or default_engine)+"/ "+(args.image or default_suricata_image)+" "
        cmd+=(args.engine or default_engine)+" -c /usr/local/etc/"+(args.engine or default_engine)+"/suricata.yaml -r /tmp/"+args.pcap+" "+(args.extra[0] or "")
        os.system(cmd)

if __name__ == "__main__":
    main()
