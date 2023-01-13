#! /bin/bash

az login

az group create  --location westus --resource-group aks-scaling-demo

az aks create \
  --resource-group aks-scaling-demo \
  --name scaledAKSCluster \
  --node-count 1 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --network-plugin azure \
   --node-vm-size standard_d11_v2 \
  --cluster-autoscaler-profile scan-interval=30s \
  --windows-admin-password <your admin password - 14 chars minimum> \
  --windows-admin-username <your admin username>

az aks get-credentials --name scaledAKSCluster -g aks-scaling-demo --overwrite
