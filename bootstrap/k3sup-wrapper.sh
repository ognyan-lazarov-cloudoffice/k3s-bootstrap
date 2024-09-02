#!/bin/bash
set -e

# Configuration
K3S_VERSION="v1.30.4+k3s1"
SERVER_IP="192.168.65.6"
AGENT_IPS="192.168.65.7"
# AGENT_IPS="IP1 IP2 IP3"
CONFIG_FILE="/path/to/config.yaml"

# Install k3sup if not present
if ! command -v k3sup &> /dev/null; then
    curl -sLS https://get.k3sup.dev | sh
    sudo install k3sup /usr/local/bin/
fi

# Install K3s server
k3sup install \
	--ip $SERVER_IP \
	--k3s-version $K3S_VERSION \
	--k3s-extra-args="--config ${CONFIG_FILE}"

# Install K3s agents
for AGENT_IP in $AGENT_IPS; do
  k3sup join \
		--ip $AGENT_IP \
		--server-ip $SERVER_IP \
		--k3s-version $K3S_VERSION
done

# Apply K3s configuration
kubectl apply -f k3s-config.yaml