## Purpose ##

The purpose of this effort is to offer easily deployed docker containers for running a pcap through multiple IDS engines

This is useful to testing out how different IDS engines handle a pcap or for testing multiple version of the same IDS engine. 

## Features ##
*	Support for multiple IDS Engines (snort, suri, bro, whatever else)
*	Support for multiple version of IDS Engines
*	Support for multiple rulesets 

## Design ##

The run_engine.sh script runs a docker container of your choice, mapping two host directories into the container.

`./policies/[enginename]/[ruleset name]`

-	This folder is designed to maintain your IDS Engine configurations
-	Gets mounted to /usr/local/etc/dockerIdsEngines/ when the container is built
-	Maintaining the rulesets and configurations on the host ensures that changes are pushed to containers when they are created
-	As additional engines become supported, I will ensure that they are created when running easy_button.sh


Place your own ruleset in the following directory
-	./Policies/[enginename]/[ruleset name of your choice]  

To add your own rules to the rulset, include a local.rules in the same directory.  
	
`./pcaps`

-	This folder is designed to hold the pcaps that you will be running through the IDS Engine  
-	Gets mounted to /tmp when the container is built  
-	Included by default is a pcap from http://www.malware-traffic-analysis.net/2015/05/11/index.html - Thanks Brad for all the awesome write ups you do!

## How-To ##

#### easy_button.sh ####
After cloning the repo, simply run the ./easy_button.sh script.  
`--install-all` install docker and all the images  
`--install-docker` install docker.  
`--install-images` enable pulling down all images  
`--proxy-setup` prompt for proxy configuration  
`--docker-snort-2.9.6.0` enable pulling down the snort-2.9.6.0 image  
`--docker-snort-2.9.7.2` enable pulling down the snort-2.9.7.2 image  
`--docker-snort-2.9.7.2-openappid` enable pulling down the snort-2.9.7.2_openappid image  
 

If no --install-images or one of the docker-snort-* flags are set, no images will be pulled down.  
The easy button script has been tested on ubuntu 14.04 and by default it assumes already have docker installed.  



#### update_ruleset.sh ####
The update_ruleset.sh script pulls down the default ETOpen ruleset.  A sane default configuration is provided in this repo  
update_ruleset.sh is run during the easy_button.sh script to allow for ease of use during initial setup.  

	
### Usage: $0 -i [image_name] -e [engine] -r [ruleset] -p [pcap] -x [extra options]

#### Mandatory options:
`-i` The docker image name to run  
`-e` The IDS engine to run (currently just snort)  
`-r` The ruleset name to for which to load the config file  
`-p` The packet capture file to read  

#### Non-mandatory options:
`-x` Any other options to the IDS engine you'd like ("-k none")  





## Examples

> ./run_engine.sh -i decodedtechsolutions/docker-snort-2.9.6.0 -e snort -r ETOpen -p test.pcap -x "-q"
