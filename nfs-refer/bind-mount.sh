#!/bin/bash
mount | grep "nfs/data" | cut -f3 -d" " > /tmp/bindmounted
#grep -v "/nfs/data       *" /etc/exports | cut -f1 -d" " > /tmp/shouldexist

makenewmount=`diff shouldexist  bindcheck  | grep "<" | cut -f2 -d" " | xargs`


for i in $makenewmount; do
        ls $i 2> /dev/null
        if [[ $? -eq 2 ]];  then
                echo "we should make a directory and double mount it"
        else
                echo "directory should exist so we are just going to bind mount 
it"
                mount -o bind $i $i
        fi

        
done
