# Alpine can only be used if/when this bug is fixed: https://bugs.alpinelinux.org/issues/8470
ARG BUILD_FROM=ubuntu:18.04
#debian:stretch-slim

FROM $BUILD_FROM

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

# kmod is needed for lsmod, and libcap2-bin is needed for confirming Linux capabilities
RUN apt-get update                                                                && \
    apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends zfsutils-linux nfs-kernel-server kmod libcap2-bin && \
    apt-get clean

RUN apt-get install -y libnss-extrausers                                             
                                                                                     
# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN mkdir -p /var/lib/nfs/rpc_pipefs && \
    mkdir -p /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049

#enable extra users files for /etc/{passwd,shadow,group}
#COPY ./nsswitch.conf /etc/nsswitch.conf

#COPY ./idmapd.conf /etc/idmapd.conf

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
