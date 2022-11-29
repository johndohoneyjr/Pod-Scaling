#! /bin/bash

az login

az aks create \
  --resource-group aks-scaling-demo \
  --name scaledAKSCluster \
  --node-count 1 \
  --enable-cluster-autoscaler \
  --min-count 1 \
  --max-count 3 \
  --cluster-autoscaler-profile scan-interval=30s

az aks get-credentials --name scaledAKSCluster -g aks-scaling-demo --overwrite
