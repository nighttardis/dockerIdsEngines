#!/bin/bash

# TODO - deal with multiple sources 
# 	Just store the source name and a url to the rules file in a flat file - source that flat file	
# TODO - support for adding new sources
# TODO - support for removing sources


# go get the latest ETOpen rules
wget -q https://rules.emergingthreats.net/open/snort-2.9.0/emerging-all.rules --output-document policy.rules


# move the ETOpen rules to the default ETOpen rulesets
cp policy.rules ./policies/snort/ETOpen/policy.rules
cp policy.rules ./policies/snort/ETOpen_OpenAppID/policy.rules
rm policy.rules


# snort openappid
wget -q https://snort.org/downloads/openappid/1793 --output-document ./policies/snort/ETOpen_OpenAppID/snort-openappid.tar.gz
tar zxf ./policies/snort/ETOpen_OpenAppID/snort-openappid.tar.gz -C ./policies/snort/ETOpen_OpenAppID/openappid/

