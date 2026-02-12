# 8. Kubernetes Basics

## What is Kubernetes (K8s)?

Container orchestration - manage many containers at scale!

## Core Concepts

| Concept | Like... |
|---------|---------|
| **Pod** | Box containing 1+ containers |
| **Deployment** | "Run 3 copies of my app" |
| **Service** | Load balancer / doorbell |
| **Node** | A machine |
| **Cluster** | Group of nodes |

## Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-starter
spec:
  replicas: 3                    # Run 3 copies!
  selector:
    matchLabels:
      app: devops-starter
  template:
    metadata:
      labels:
        app: devops-starter
    spec:
      containers:
      - name: devops-starter
        image: username/devops-starter:latest
        ports:
        - containerPort: 3000
```

## Service YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: devops-starter-service
spec:
  type: NodePort
  selector:
    app: devops-starter
  ports:
  - port: 3000
    targetPort: 3000
    nodePort: 30001
```

## Commands

```bash
# Apply configuration
kubectl apply -f file.yaml

# View resources
kubectl get pods
kubectl get deployments
kubectl get services

# Scaling
kubectl scale deployment devops-starter --replicas=5

# Debugging
kubectl logs pod-name
kubectl describe pod pod-name

# Delete
kubectl delete -f file.yaml
```

## Minikube (Local K8s)

```bash
minikube start              # Start cluster
minikube status             # Check status
minikube service svc --url  # Get service URL
minikube stop               # Stop cluster
```

## Why Kubernetes?

- **Availability** - Never go down
- **Scalability** - Handle any traffic
- **Self-healing** - Auto-restart crashes
- **Rolling updates** - Zero-downtime deploys
