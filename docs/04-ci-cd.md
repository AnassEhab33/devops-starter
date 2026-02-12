# 4. CI/CD with GitHub Actions

## What is CI/CD?

| Term | Meaning |
|------|---------|
| **CI** (Continuous Integration) | Automatically test every push |
| **CD** (Continuous Deployment) | Automatically deploy after tests pass |

## GitHub Actions File

Location: `.github/workflows/ci.yml`

```yaml
name: CI

on: [push]              # Trigger on every push

jobs:
  test:
    runs-on: ubuntu-latest    # Use Ubuntu server
    steps:
      - uses: actions/checkout@v4        # Get code
      - uses: actions/setup-node@v4      # Install Node.js
        with:
          node-version: 18
      - run: npm install                 # Install dependencies
      - run: npm test                    # Run tests!
```

## Key Concepts

| Part | Meaning |
|------|---------|
| `on: [push]` | When to run |
| `jobs:` | List of tasks |
| `runs-on:` | What machine to use |
| `steps:` | Sequence of actions |
| `uses:` | Pre-made action |
| `run:` | Shell command |

## Flow

```
git push → GitHub Actions → Tests run → Pass ✅ or Fail ❌
```

## GitHub Secrets

Store sensitive data:
1. Repo → Settings → Secrets → Actions
2. Add secret (e.g., `DOCKERHUB_TOKEN`)
3. Use in workflow: `${{ secrets.DOCKERHUB_TOKEN }}`
