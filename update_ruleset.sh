#!/bin/bash

# TODO - deal with multiple sources 
# 	Just store the source name and a url to the rules file in a flat file - source that flat file	
# TODO - support for adding new sources
# TODO - support for removing sources

# ETOpen Default Ruleset
mkdir --parents /usr/local/etc/dockerIdsEngines/snort/ETOpen/

chown :docker /usr/local/etc/dockerIdsEngines/snort/ETOpen/

wget -q http://rules.emergingthreats.net/open/snort-2.9.0/emerging-all.rules --output-document /usr/local/etc/dockerIdsEngines/snort/ETOpen/policy.rules
# Copy a sane default configuration
cp ETOpen_conf/* /usr/local/etc/dockerIdsEngines/snort/ETOpen/



# snort vrt default ruleset
# OpenAppID updating