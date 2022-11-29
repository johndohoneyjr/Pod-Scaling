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

