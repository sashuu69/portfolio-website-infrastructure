#!/bin/bash

if [ -z "$1" ]; then
    echo "No argument provided."
    exit 1
fi

set -e
export DEBIAN_FRONTEND="noninteractive"
export LANG=C

echo "[INFO] Portfolio Website Infrastructure"
echo "[INFO] Updating system..."
apt-get update -y && apt-get upgrade -y

echo "[INFO] Installing Terraform, Ansible and necessary packages..."
apt install -y gnupg software-properties-common wget
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
add-apt-repository --yes --update ppa:ansible/ansible
apt-get update -y && apt-get install -y terraform ansible

echo "[INFO] Setting up Terraform for bringing up Portfolio Website..."
terraform init

if [ "$1" == "apply" ]; then
    ./apply.sh
elif [ "$1" == "destroy" ]; then
    ./destroy.sh
else
    echo "Invalid argument provided."
    exit 1
fi
