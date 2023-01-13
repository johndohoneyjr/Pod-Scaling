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
  --os-sku Windows2019 \
  --cluster-autoscaler-profile scan-interval=30s \
  --windows-admin-password <your admin password> \
  --windows-admin-username <your admin username>

az aks get-credentials --name scaledAKSCluster -g aks-scaling-demo --overwrite
