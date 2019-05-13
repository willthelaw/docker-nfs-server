# Alpine can only be used if/when this bug is fixed: https://bugs.alpinelinux.org/issues/8470
#debian:stretch-slim

FROM ubuntu:18.04

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
ARG DEBIAN_FRONTEND=noninteractive

#google cloud sdk for getting stuff
# Create environment variable for correct distribution
RUN apt-get update && apt-get -y install curl gpg && export CLOUD_SDK_REPO="cloud-sdk-bionic" && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

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

# Add Tini
#ENV TINI_VERSION v0.18.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
#RUN chmod +x /sbin/tini
#ENTRYPOINT ["/sbin/tini", "--"]

# setup entrypoint
COPY ./docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
