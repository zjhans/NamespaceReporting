#!/bin/bash
today=$(date +'%Y%m%d')
scp username@clustername.comcast.net:/home/username/path/EmptyNamespaces_$today.csv /home/username/Documents/
scp username@clustername.comcast.net:/home/username/path/PopulatedNamespaces_$today.csv /home/username/Documents/
