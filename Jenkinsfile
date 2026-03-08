pipeline {
    agent any
    stages {
        stage('Install'){
            sh 'npm install'
        }
        stage('Test'){
            sh 'npm test'
        }
        stage('Build'){
            sh 'docker build -t anassehab33/devops-starter:latest .'
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