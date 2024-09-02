#!/bin/bash
set -e

# Configuration
K3S_VERSION="v1.30.4+k3s1"
SERVER_IP="192.168.65.8"
# AGENT_IPS="192.168.1.101 192.168.1.102"

# Install k3sup if not present
if ! command -v k3sup &> /dev/null; then
    curl -sLS https://get.k3sup.dev | sh
    sudo install k3sup /usr/local/bin/
fi

# Install K3s server
k3sup install --ip $SERVER_IP --k3s-version $K3S_VERSION

# Install K3s agents
for AGENT_IP in $AGENT_IPS; do
    k3sup join --ip $AGENT_IP --server-ip $SERVER_IP --k3s-version $K3S_VERSION
done

# Apply K3s configuration
kubectl apply -f k3s-config.yaml