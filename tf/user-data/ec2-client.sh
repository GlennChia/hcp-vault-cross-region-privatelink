#!/bin/bash
dnf install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf -y install vault

cat << EOF > /etc/profile.d/vault.sh
export VAULT_ADDR=${vault_address}
export VAULT_TOKEN=${vault_token}
export VAULT_NAMESPACE=admin
EOF