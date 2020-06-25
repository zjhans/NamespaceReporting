#!/bin/bash
today=$(date +'%Y%m%d')
yesterday=$(date -d "yesterday 11:00" '+%Y%m%d')

# Cleanup yesterday's run
if [ -d "/home/username/ClusterInventories/AllClusters_$yesterday" ]; then
	rm -rf /home/username/ClusterInventories/AllClusters_$yesterday
fi

# Make a new dir for today's run
mkdir /home/username/ClusterInventories/AllClusters_$today

# Copy down all pod/namespaces reports from the clusters
scp user@hostname1.comcast.net:/root/ClusterInventory/EmptyNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname1.comcast.net:/root/ClusterInventory/PopulatedNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname2.comcast.net:/root/ClusterInventory/PopulatedNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname2:/root/ClusterInventory/EmptyNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname3.comcast.net:/root/ClusterInventory/PopulatedNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname3.comcast.net:/root/ClusterInventory/EmptyNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname4.comcast.net:/root/ClusterInventory/PopulatedNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today
scp user@hostname4.comcast.net:/root/ClusterInventory/EmptyNamespaces_$today.csv /home/username/ClusterInventories/AllClusters_$today

# Zip up for easier download to local
tar -czf AllClusterReports_$today.tgz /home/username/ClusterInventories/*_$today.csv
