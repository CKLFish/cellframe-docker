FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

# 1. Get the necessary packages for setting up public key.

RUN apt-get update && apt-get -y install wget gnupg procps

RUN echo "deb https://debian.pub.demlabs.net/public bullseye main" > /etc/apt/sources.list.d/demlabs.list

RUN wget https://debian.pub.demlabs.net/public/public-key.gpg && apt-key add public-key.gpg && rm public-key.gpg

# 2. Set package selections before installing the cellframe-node

RUN echo "cellframe-node cellframe-node/subzero_enabled select true" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/server_addr	string	0.0.0.0" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/auto_online	select	true" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/kelvpn_minkowski_node_type	select	full" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/kelvin_testnet_enabled	select	true" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/server_port	string	8079" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/kelvin_testnet_node_type	select	full" | debconf-set-selections  \
    && echo "cellframe-node cellframe-node/server_enabled	select	true" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/debug_mode	select	false" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/core_t_node_type	select	full" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/kelvpn_minkowski_enabled	select	true" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/subzero_node_type	select	full" | debconf-set-selections \
    && echo "cellframe-node cellframe-node/core_t_enabled	select	true" | debconf-set-selections

# 3. Install the node

RUN apt-get update && apt-get -y install cellframe-node

# 4. Cleanup

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 5. Symlink node executable to $PATH just in case

RUN ln -sv /opt/cellframe-node/bin/cellframe-node /usr/bin/

# 6. Expose the default cellframe-node port

EXPOSE 8079