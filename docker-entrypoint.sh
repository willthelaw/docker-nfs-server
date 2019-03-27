#!/bin/bash
set -eu

#make directories we need for nfs
if [ ! -d "/nfs/data" ]; then
	mkdir -p /nfs/data
fi

if [ ! -d "/nfs/system/nfs/sm" ]; then
        mkdir -p /nfs/system/nfs/sm
fi

if [ ! -d "/nfs/system/nfs/rpc_pipefs" ]; then
        mkdir -p /nfs/system/nfs/rpc_pipefs
fi

if [ ! -d "/nfs/system/nfs/v4recovery" ]; then
        mkdir -p /nfs/system/nfs/v4recovery
fi

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
#--no-nfs-version 3 --no-nfs-version 2
exec rpc.mountd -u --no-nfs-version 2 --manage-gids --foreground --port 32767
