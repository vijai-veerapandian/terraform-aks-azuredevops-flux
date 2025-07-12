#!/bin/bash
set -e

# Variables passed from Terraform template
AZP_URL="${azp_url}"
AZP_TOKEN="${azp_token}"
AZP_POOL="${azp_pool}"
ADMIN_USERNAME="${admin_username}"
VM_NAME=$(hostname)

# Update packages and install dependencies
apt-get update -y
apt-get install -y curl jq unzip

# Install Docker for container-based builds
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
usermod -aG docker $ADMIN_USERNAME

# Determine latest Azure DevOps agent version
AZP_AGENT_VERSION=$(curl -s "https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest" | jq -r '.tag_name' | sed 's/v//')
AZP_AGENT_PACKAGE_URL="https://vstsagentpackage.azureedge.net/agent/${AZP_AGENT_VERSION}/vsts-agent-linux-x64-${AZP_AGENT_VERSION}.tar.gz"

# Create a folder for the agent, download, and extract it
mkdir -p /myagent && cd /myagent
curl -fkSL -o vsts-agent.tar.gz $AZP_AGENT_PACKAGE_URL
tar -zxvf vsts-agent.tar.gz

# Grant ownership to the admin user
chown -R $ADMIN_USERNAME:$ADMIN_USERNAME /myagent

# Configure the agent to run unattended
runuser -l $ADMIN_USERNAME -c "./config.sh --unattended --url $AZP_URL --auth pat --token $AZP_TOKEN --pool $AZP_POOL --agent $VM_NAME --acceptTeeEula --work _work --replace"

# Install and start the agent as a systemd service
./svc.sh install $ADMIN_USERNAME
./svc.sh start