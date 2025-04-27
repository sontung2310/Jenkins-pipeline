pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sontung2310/Jenkins-pipeline.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t flask-auth-app:latest .'
            }
        }

        stage('Test') {
            steps {
                sh 'docker run --rm flask-auth-app:latest pytest'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
