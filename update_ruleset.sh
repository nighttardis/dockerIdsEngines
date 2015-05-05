#!/bin/bash

# TODO - deal with multiple sources 
# 	Just store the source name and a url to the rules file in a flat file - source that flat file	
# TODO - support for adding new sources
# TODO - support for removing sources

# ETOpen Default Ruleset
mkdir --parents /usr/local/etc/dockerIdsEngines/snort/ETOpen/

chown :docker /usr/local/etc/dockerIdsEngines/snort/ETOpen/

# go get the latest ETOpen rules
wget -q http://rules.emergingthreats.net/open/snort-2.9.0/emerging-all.rules --output-document policy.rules

# move the ETOpen rules to the default ETOpen rulesets
cp policy.rules /usr/local/etc/dockerIDSEngines/snort/ETOpen/policy.rules
cp policy.rules /usr/local/etc/dockerIDSEngines/snort/ETOpen_OpenAppID/policy.rules
rm policy.rules

# Copy a default configurations
cp ETOpen_conf/* /usr/local/etc/dockerIdsEngines/snort/ETOpen/
cp ETOpen_OpenAppID/* /usr/local/etc/dockerIDSEngines/snort/ETOpen_OpenAppID/

# snort openappid
wget -q wget https://snort.org/downloads/openappid/1516 --output-document /usr/local/etc/dockerIDSEngines/snort/ETOpen_OpenAppID/snort-openappid.tar.gz
tar zxf /usr/local/etc/dockerIDSEngines/snort/ETOpen_OpenAppID/snort-openappid.tar.gz -C /usr/local/etc/dockerIDSEngines/snort/ETOpen_OpenAppID/openappid/

