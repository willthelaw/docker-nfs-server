#!/bin/bash
nfslinks=`cut -f1 -d" " < exports-home | grep nfs | xargs`
for i in nfslinks; do
        if [ "$i" != "/nfs/data" ]; then
                mkdir $i
                mount -o bind $i $i
        fi
done
