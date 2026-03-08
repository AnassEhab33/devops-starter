pipeline {
    agent any
    environment {
        PATH = "/usr/bin:/usr/local/bin:${env.PATH}"
    }
    stages {
        stage('Install'){
            steps{
                sh 'npm install'
            }
        }
        stage('Test'){
            steps{
                sh 'npm test'
            }
        }
        stage('Build'){
            steps{
                sh 'docker build -t anassehab33/devops-starter:latest .'
            }
        }
    }
    post {
        success {
           echo "Pipeline passed !!!! Yessss !!!! :) "
        }
        failure {
            echo "Pipeline failed :("
        }
    }
}