#!/bin/bash

if [ -f config.sh ];
then
   source config.sh
elif [ -f ../config.sh ];
then
	source ../config.sh
else
   echo "Config file config.sh does not exist"
fi