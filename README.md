
### Run the simple Go Container application

```
docker build -t simple-go-app .
```
```
docker run -p 8080:8080 simple-go-app
```

### Test the application

```
curl http://localhost:8080
```

### Tag the docker image as per GitOps standard.

```
docker tag simple-go-app ghcr.io/<vijai-veerapandian>/simple-go-app:1.0.0

```

### Push the docker image into the github package image repository

with the copied Personal access tokens > tokens (classic) or fine-graned one export that to a variable lets say CR_PAT.

```
export CR_PAT=COPIED_PAT
echo $CR_PAT | docker login ghcr.io -u <github-username> --password-stdin

docker push ghcr.io/<github-username>/simple-go-app:1.0.0
```

### Now, Use local Kind cluster to generate Kubernetes manifests file to enable this application to run on top of kubernetes cluster through deployment.

```
kind create cluster context local-man
kind create cluster-info
```

### Once Kind is up as per above command. Now, use kubectl cmds to generate application deployment yaml file and loadbalancer yaml file.

```
kubectl create deployment simple-go-app --image=ghcr.io/<github-username>/simple-go-app:1.0.0 --port=8080 -o yaml > app.yaml
```

### Make sure Resource limit are set on the container to consume on the deployment yaml file using this as an example up-part from other cleanup.

```
resources:
  requests:
    cpu: "100m"
    memory: "64Mi"
  limits:
    cpu: "250m"
    memory: "128Mi"
```

### Expose the application via loadbalancer to access it.

```
kubectl expose deployment simple-go-app --port=8080 --target-port=80 -o yaml > app-svc.yaml
```

### Now, Test the application on the local kind k8s cluster

```
kubectl apply -f app.yaml
kubectl apply -f app-svc.yaml
```
< add screenshot>>

### Now, delete the deployment

```
kubectl delete -f app.yaml
kubectl delete -f app-svc.yaml
```

### 


