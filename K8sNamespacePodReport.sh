#!/bin/bash
today=$(date +'%Y%m%d')
if [ -f /root/ClusterInventory/AllActiveNamespaces.txt ]; then
     rm -f /root/ClusterInventory/AllActiveNamespaces.txt
fi

kubectl get namespaces | awk '{print $1}' | grep -v NAME >> AllActiveNamespaces.txt
for i in `cat AllActiveNamespaces.txt`
     do PODCNT=`kubectl get pods -n $i | grep -v READY | grep 'Running\|Completed' | wc -l`
     if [ "$PODCNT" -ge "1" ]
     then
          echo "$i" >> PopulatedNamespaces_$today.csv
    else 
          echo "$i" >> EmptyNamespaces_$today.csv
     fi
done
