# 1. Node.js & npm Basics

## What is Node.js?

**Node.js** = JavaScript that runs on your computer (not just in browsers)

```javascript
// This runs on your computer, not in Chrome!
console.log('Hello from Node.js!');
```

## What is npm?

**npm** = Node Package Manager - downloads and manages code libraries

### Common Commands

```bash
npm init              # Create package.json
npm install           # Install all dependencies
npm install express   # Add a new package
npm start             # Run the "start" script
npm test              # Run tests
```

## package.json

Your project's "ID card" - lists dependencies and scripts:

```json
{
  "name": "devops-starter",
  "scripts": {
    "start": "node server.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^5.2.1"
  },
  "devDependencies": {
    "jest": "^30.2.0"
  }
}
```

| Section | Purpose |
|---------|---------|
| `scripts` | Commands you can run |
| `dependencies` | Packages needed to run |
| `devDependencies` | Only for development/testing |

## package-lock.json

Locks exact versions of all packages. Always commit this file!

## node_modules/

Downloaded packages folder. Never commit this (add to .gitignore)!
