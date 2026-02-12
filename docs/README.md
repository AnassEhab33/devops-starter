# DevOps Learning Guide 📚

A complete guide covering everything you learned in your DevOps journey!

## 📁 Contents

| File | Topic |
|------|-------|
| [01-nodejs-npm.md](01-nodejs-npm.md) | Node.js & npm basics |
| [02-testing.md](02-testing.md) | Automated testing with Jest |
| [03-docker.md](03-docker.md) | Docker & containers |
| [04-ci-cd.md](04-ci-cd.md) | CI/CD with GitHub Actions |
| [05-docker-hub.md](05-docker-hub.md) | Pushing to Docker Hub |
| [06-cloud-deployment.md](06-cloud-deployment.md) | Deploy to Render |
| [07-docker-compose.md](07-docker-compose.md) | Multi-container apps |
| [08-kubernetes.md](08-kubernetes.md) | Kubernetes basics |

## 🗺️ Your DevOps Journey

```
Node.js → Testing → Docker → CI/CD → Docker Hub → Cloud → Compose → Kubernetes
   ✅        ✅        ✅       ✅        ✅         ✅       ✅         ✅
```

## 🎯 Quick Reference

```bash
# Git
git add . && git commit -m "message" && git push

# Docker
docker build -t image-name .
docker run -p 3000:3000 image-name
docker push username/image-name

# Docker Compose
docker-compose up
docker-compose down

# Kubernetes
kubectl apply -f file.yaml
kubectl get pods
kubectl get services
kubectl scale deployment name --replicas=5
```
