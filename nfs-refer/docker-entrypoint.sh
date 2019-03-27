#!/bin/bash

set -eu

#get nfsdirs to create from exports
nfslinks=`cut -f1 -d" " < /etc/exports.d/nfs.exports | grep nfs | xargs`
for i in $nfslinks; do
	if [ "$i" != "/nfs/data" ]; then
		if [ ! -d $i ]; then
			echo "making directory"
			mkdir $i
			echo "bind mounting directory"
			mount -v -o bind $i $i
		else
			echo "bind mounting directory"
			mount -v -o bind $i $i
		fi
	fi
done


mount -av


#all this should be moved to supervisord

#turn off leases
echo 0 > /proc/sys/fs/leases-enable


exportfs -fra
rpcbind
rpc.idmapd
rpc.statd --port 32765 --outgoing-port 32766
rpc.nfsd --port 2049 -U
#notify clients it rebooted
#sm-notify -v `home.wla`
#--no-nfs-version 3 --no-nfs-version 2
exec rpc.mountd -u --no-nfs-version 2 --manage-gids --foreground --port 32767
