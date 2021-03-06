#!/bin/bash
# Loops through each namespace on the cluster, checking the number of running pods and listing each namespace in one of two csv files depending on if it has active pods or not

today=$(date +'%Y%m%d')
if [ -f /root/ClusterInventory/AllActiveNamespaces.txt ]; then
     rm -f /root/ClusterInventory/AllActiveNamespaces.txt
fi

oc get namespaces | awk '{print $1}' | grep -v NAME >> AllActiveNamespaces.txt
for i in `cat AllActiveNamespaces.txt`
     do PODCNT=`oc get pods -n $i | grep -v READY | grep 'Running\|Completed' | wc -l`
     if [ "$PODCNT" -ge "1" ]
     then
          echo "$i" >> PopulatedNamespaces_$today.csv
    else 
          echo "$i" >> EmptyNamespaces_$today.csv
     fi
done
