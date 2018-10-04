#!/bin/bash

set -eu

#create referal directories



mount -av

#go through exports and make directory

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
