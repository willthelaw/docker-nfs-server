FROM nero-maas.stanford.edu:5000/docker-nfs-server 

# set different entry point for nfs-referrals

COPY ./docker-entrypoint.sh /usr/local/bin
COPY ./bind-mount.sh /usr/local/bin

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN echo "" > /etc/exports

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
