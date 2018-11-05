# Alpine can only be used if/when this bug is fixed: https://bugs.alpinelinux.org/issues/8470
ARG BUILD_FROM=ubuntu:18.04
#debian:stretch-slim

FROM $BUILD_FROM

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

# kmod is needed for lsmod, and libcap2-bin is needed for confirming Linux capabilities
RUN apt-get update                                                                && \
    apt-get -y dist-upgrade && \
	    apt-get install -y --no-install-recommends net-tools dnsutils nfs-kernel-server kmod libcap2-bin

RUN apt-get install -y libnss-extrausers keyutils screen vim && apt-get clean                                          
                                                                                     
# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN mkdir -p /var/lib/nfs/rpc_pipefs && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

#RUN rmdir  /var/lib/nfs/v4recovery && \
#    ln -s /nfs/v4recovery /var/lib/nfs/v4recovery


EXPOSE 2049

#enable extra users files for /etc/{passwd,shadow,group}
COPY ./nsswitch.conf /etc/nsswitch.conf

#COPY ./nlm.conf /etc/modprobe.d

COPY ./idmapd.conf /etc/idmapd.conf

COPY ./nfs-common /etc/default/nfs-common

COPY ./nfs-kernel-server /etc/default/nfs-kernel-server

COPY ./exports /etc/exports

#add in tini
# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini
ENTRYPOINT ["/tini", "--"]

# setup entrypoint
COPY ./docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
CMD ["/usr/local/bin/docker-entrypoint.sh"]
