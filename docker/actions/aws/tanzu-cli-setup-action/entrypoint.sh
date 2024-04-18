#!/usr/bin/env bash

# Entrypoint for tanzu-cli-setup-action

# This script expects that the following environment variables have been set:
#
# * TANZU_CLI_ENABLED
# * AWS_ACCESS_KEY_ID
# * AWS_SECRET_ACCESS_KEY
#

if [ x"${AWS_ACCESS_KEY_ID}" == "x" ] || [ x"${AWS_SECRET_ACCESS_KEY}" == "x" ]; then
  echo "Expected AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY enviroment variables to have been set!"
  exit 1;
fi

if [ x"${AWS_SESSION_TOKEN}" == "x" ]; then
  echo "Session token not supplied."
else
  echo "Session token supplied."
fi

if [ "${TANZU_CLI_ENABLED}" == "true" ]; then
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | tee /etc/apt/sources.list.d/tanzu.list
  apt update
  apt install -y tanzu-cli
  tanzu config eula accept
  TANZU_CLI_CEIP_OPT_IN_PROMPT_ANSWER="no"
  tanzu plugin group search
  tanzu plugin install --group vmware-tanzucli/essentials
  tanzu plugin install --group vmware-tap/default
  tanzu plugin install --group vmware-tap_saas/app-developer
  tanzu plugin install --group vmware-tap_saas/platform-engineer
  tanzu plugin install --group vmware-tkg/default
  tanzu plugin install --group vmware-tmc/default
  tanzu plugin install --group vmware-vsphere/default
else
  echo "Not installing tanzu CLI nor configuring plugins"
fi

if [ -z "$2" ]; then
  echo "Base64 encoded KUBECONFIG contents not supplied"
else
  echo "Exporting KUBECONFIG environment variable."
  mkdir -p $HOME/.kube
  echo "$2" | base64 -d > $HOME/.kube/config
  chmod 600 $HOME/.kube/config
  export KUBECONFIG=$HOME/.kube/config
fi

echo "Executing command."
echo "> $1"
eval $1

if [ -z "$3" ]; then
  echo "No need to query for output; resultant output will be blank"
  result=""
else
  echo "Querying for output."
  echo "> $3"
  result=$(eval $3)
fi

echo "result=${result}" >> $GITHUB_OUTPUT