#!/bin/bash
today=$(date +'%Y%m%d')

# Cleanup previously day's run, if file is present
if [ -f /root/ClusterInventory/AllActiveNamespaces.txt ]; then
     rm -f /root/ClusterInventory/AllActiveNamespaces.txt
fi

# Generate a list of all current, active namespaces on the cluster
oc get namespaces | awk '{print $1}' | grep -v NAME > /root/ClusterInventory/AllActiveNamespaces.txt

# Loop through active namespaces and find any with cronjobs - these are assumed to be in use
for i in `cat /root/ClusterInventory/AllActiveNamespaces.txt`
     do CRONCNT=`oc get cronjobs -n $i | grep -v NAME | wc -l`
     if [ "$CRONCNT" -ge "1" ]
     then
          echo "$i" >> /root/ClusterInventory/CLUSTNAME-CronjobNamespaces_$today.csv
    else
          echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoCronjobsNamespaces_$today.csv
     fi
done

# Loop through namespaces without cronjobs and find any with pods - these are also assumed to be in use
for i in `cat /root/ClusterInventory/HOC1-NoCronjobNamespaces_$today.csv`
    do PODCNT=`oc get pods -n $i | grep -v READY | grep 'Running\|Completed' | wc -l`
    if [ "$PODCNT" -ge "1" ]
    then
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-PodsNamespaces_$today.csv
    else
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoPodNamespaces_$today.csv
    fi
done

# Loop through namespaces without pods or cronjobs and find any workloads - these may or may not be in use
# Anything that has no active workloads/resources is assumed to be dead and no migration is required
for i in `cat /root/ClusterInventory/HOC1-NoPodNamespaces_$today.csv`
    do RESCNT=`oc get all -n $i | grep -v NAMESPACE | wc -l`
    if [ "$RESCNT" -ge "1" ]
    then
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-ActResNamespaces_$today.csv
    else
        echo "$i" >> /root/ClusterInventory/CLUSTNAME-NoActResNamespaces_$today.csv
    fi
done
