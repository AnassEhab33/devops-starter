# 5. Pushing to Docker Hub

## What is Docker Hub?

Container registry - like GitHub but for Docker images!

## Manual Push

```bash
# 1. Login
docker login

# 2. Build with your username
docker build -t YOUR_USERNAME/devops-starter:latest .

# 3. Push
docker push YOUR_USERNAME/devops-starter:latest
```

## Automated Push (CI/CD)

Add to `.github/workflows/ci.yml`:

```yaml
build-and-push:
  needs: test                    # Wait for tests
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    
    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        push: true
        tags: ${{ secrets.DOCKERHUB_USERNAME }}/devops-starter:latest
```

## Required Secrets

Add to GitHub:
- `DOCKERHUB_USERNAME` - your Docker Hub username
- `DOCKERHUB_TOKEN` - access token (Hub → Settings → Security)

## Flow

```
git push → Tests pass → Build image → Push to Docker Hub
```
