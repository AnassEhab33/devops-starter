# 7. Docker Compose

## What is Docker Compose?

Run multiple containers with one command!

## docker-compose.yml

```yaml
services:
  app:
    build: .                    # Build from Dockerfile
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://postgres:password@db:5432/devops
    depends_on:
      - db                      # Start db first

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=devops
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## Key Concepts

| Part | Meaning |
|------|---------|
| `services:` | List of containers |
| `build: .` | Build from Dockerfile |
| `image:` | Use pre-built image |
| `depends_on:` | Start order |
| `volumes:` | Persist data |

## Commands

```bash
docker-compose up       # Start all
docker-compose up -d    # Start in background
docker-compose down     # Stop all
docker-compose logs     # View logs
docker-compose ps       # List services
```

## Why Use It?

- One command starts everything
- Containers can talk by name (e.g., `db`)
- Easy to share setup
