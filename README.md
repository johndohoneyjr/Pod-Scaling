# Pod-Scaling

Deploy Azure RG and AKS Cluster -- See ./scripts
Get Credentials
```
kubectl apply -f https://k8s.io/examples/application/php-apache.yaml
```
Create the HorizontalPodAutoscaler:
```
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

# You can use "hpa" or "horizontalpodautoscaler"; either name works OK.
kubectl get hpa
```
The HPA controller will increase and decrease the number of replicas (by updating the Deployment) to maintain an average CPU utilization across all Pods of 50%. The Deployment then updates the ReplicaSet - this is part of how all Deployments work in Kubernetes - and then the ReplicaSet either adds or removes Pods based on the change to its .spec.

Next, see how the autoscaler reacts to increased load. To do this, you'll start a different Pod to act as a client. The container within the client Pod runs in an infinite loop, sending queries to the php-apache service.


```
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done
```

Now check 
```
kubectl get hpa php-apache --watch
```
# Cluster Auto-Scaling

```
# Create a dedicated namespace
kubectl create namespace scaling-demo

# Deploy the application to AKS
kubectl apply -f https://raw.githubusercontent.com/johndohoneyjr/Pod-Scaling/main/manifests/cluster-scale.yaml -n scaling-demo

kubectl scale deploy/demo -n scaling-demo --replicas 400

# In one terminal - watch pods scale
kubectl get po -n scaling-demo -w

# In another termina watch nodes scale
kubectl get nodes -w

#in another terminal, watch the load balance
kubectl top nodes
```
## Scale Down
```
kubectl scale deploy/demo -n scaling-demo --replicas 4

##
# Speed up scale down
az aks update -g aks-scaling-demo -n scaledAKSCluster --cluster-autoscaler-profile scale-down-delay-after-delete=30s scale-down-unneeded-time=1m
```
