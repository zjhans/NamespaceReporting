#!/bin/bash
today=$(date +'%Y%m%d')

# Cleanup previously day's run, if file is present
if [ -f /root/ClusterInventory/AllActiveNamespaces.txt ] 
then
     rm -f /root/ClusterInventory/AllActiveNamespaces.txt
fi

# Generate a list of all active namespaces on the cluster
oc get namespaces | awk '{print $1}' | grep -v NAME > /root/ClusterInventory/AllNamespaces.txt

# Loop through active namespaces and find any with cronjobs - these are assumed to be in use
for i in `cat /root/ClusterInventory/AllNamespaces.txt`
     do CRONCNT=`oc get cronjobs -n $i | grep -v NAME | wc -l`
     if [ "$CRONCNT" -ge "1" ]
     then
          echo "$i" >> /root/ClusterInventory/CLUSTNAME-Cronjobs_$today.csv
    else
          echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoCronjobs_$today.csv
     fi
done

# Loop through namespaces without cronjobs and find any with pods - these are also assumed to be in use
for i in `cat /root/ClusterInventory/CLUSTNAME-NoCronjobs_$today.csv`
    do PODCNT=`oc get pods -n $i | grep -v READY | grep 'Running\|Completed' | wc -l`
    if [ "$PODCNT" -ge "1" ]
    then
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-Pods_$today.csv
    else
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoPods_$today.csv
    fi
done

# Loop through namespaces without pods OR cronjobs and find any other active resources/workloads - these may or may not be in use
# Any namespace that has no active workloads/resources is assumed to be dead
for i in `cat /root/ClusterInventory/CLUSTNAME-NoPods_$today.csv`
    do RESCNT=`oc get all -n $i | grep -v NAMESPACE | wc -l`
    if [ "$RESCNT" -ge "1" ]
    then
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-ActResources_$today.csv
    else
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoActResources_$today.csv
    fi
done
