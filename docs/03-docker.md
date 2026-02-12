# 3. Docker & Containers

## What is Docker?

**Container** = Your app + everything it needs, packaged together

Solves: "It works on my machine!" problem

## Dockerfile

Blueprint for building a container:

```dockerfile
FROM node:18-alpine       # Base image
WORKDIR /app              # Working directory
COPY package*.json ./     # Copy package files
RUN npm install           # Install dependencies
COPY . .                  # Copy code
EXPOSE 3000               # Document port
CMD ["npm", "start"]      # Start command
```

## .dockerignore

Files to exclude from container:

```
node_modules
.git
.gitignore
Dockerfile
```

## Common Commands

```bash
# Build image
docker build -t image-name .

# Run container
docker run -p 3000:3000 image-name

# Run in background
docker run -d -p 3000:3000 image-name

# Run interactive shell
docker run -it image-name sh

# List containers
docker ps

# Stop container
docker stop container-id

# View logs
docker logs container-id
```

## Visual

```
Dockerfile (recipe) → docker build → Image (frozen meal) → docker run → Container (running!)
```
