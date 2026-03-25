# Jenkinsfile - Pipeline as Code

## What is a Jenkinsfile?

**Jenkinsfile** = CI/CD pipeline written as code, stored in your repo!

| | GitHub Actions | Jenkins |
|---|---|---|
| File | `.github/workflows/ci.yml` | `Jenkinsfile` |
| Language | YAML | Groovy |
| Location | In your repo | In your repo |
| Concept | Same! Pipeline as code! | Same! |

## Jenkinsfile Syntax

```groovy
pipeline {
    agent any              // Run on any available machine

    stages {
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker') {
            steps {
                sh 'docker build -t anassehab33/devops-starter:latest .'
            }
        }
    }

    post {
        success {
            echo 'Pipeline passed! ✅'
        }
        failure {
            echo 'Pipeline failed! ❌'
        }
    }
}
```

## Explained Line by Line

| Part | Meaning |
|------|---------|
| `pipeline { }` | "This is a pipeline" |
| `agent any` | "Run on any available Jenkins machine" |
| `stages { }` | "Here are the steps" |
| `stage('Install')` | A named step (shows in Jenkins UI) |
| `steps { }` | Commands to run |
| `sh 'npm install'` | Run a shell command |
| `post { }` | What to do after pipeline finishes |
| `success { }` | Runs only if everything passed |
| `failure { }` | Runs only if something failed |

## Your Comparison

**GitHub Actions (ci.yml):**
```yaml
steps:
  - run: npm install
  - run: npm test
```

**Jenkins (Jenkinsfile):**
```groovy
stage('Install') { steps { sh 'npm install' } }
stage('Test')    { steps { sh 'npm test' } }
```

**Same concept, different syntax!**

## Steps to Set Up

### 1. Create the Jenkinsfile
Create a file called `Jenkinsfile` (no extension!) in your project root.

### 2. Configure Jenkins Job
1. In Jenkins → **New Item** → **Pipeline**
2. Under **Pipeline** section:
   - Definition: **"Pipeline script from SCM"**
   - SCM: **Git**
   - Repository URL: `https://github.com/AnassEhab33/devops-starter.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
3. **Save**

### 3. Push and Watch
```bash
git add Jenkinsfile
git commit -m "Add Jenkinsfile for Jenkins pipeline"
git push
```

Then trigger a build in Jenkins and watch the stages!

## Visual: Jenkins Pipeline View

```
┌──────────┐   ┌──────────┐   ┌──────────────┐
│ Install  │ → │   Test   │ → │ Build Docker │
│  ✅ 5s   │   │  ✅ 3s   │   │   ✅ 30s     │
└──────────┘   └──────────┘   └──────────────┘
```

Jenkins shows each stage as a visual block!
