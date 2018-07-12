#!/bin/bash

set -eu

mount -av

exportfs -ra
rpcbind
rpc.statd
rpc.nfsd

exec rpc.mountd --foreground
