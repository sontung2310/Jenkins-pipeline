pipeline {
    agent any

    environment {
        IMAGE_NAME = 'sit753_hd-flaskapp'
        SONAR_TOKEN = credentials('SONAR_TOKEN')
        SNYK_TOKEN = credentials('Snyk-api-token')
        TEST_ENV = 'test'
        RELEASE_TAG = "release-${BUILD_NUMBER}"
        NEW_RELIC_LICENSE_KEY = credentials('NEW_RELIC_LICENSE_KEY')

    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sontung2310/Jenkins-pipeline.git'
            }
        }
        stage('Build stage') {
            steps {
                echo 'Build Docker image for Flask application'
                sh 'docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:$RELEASE_TAG .'
            }
        }

        stage('Test stage') {
            steps {
                echo 'Run unit tests using pytest'
                sh 'docker run --rm $IMAGE_NAME:latest pytest'
            }
        }
        
        stage('Code quality analysis stage') {
            steps {
                echo 'Code quality analysis using SonarCloud'
                sh '''
            # Go to your project root where sonar-project.properties is located
            cd /Users/sontung/Desktop/3.Project/trimester_3/SIT753_HD
            
            # Download and extract SonarScanner CLI
            curl -sSLo sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006.zip
            unzip -oq sonar-scanner.zip
            
            # Add scanner to PATH
            export PATH=$PWD/sonar-scanner-5.0.1.3006/bin:$PATH
            
            # Run scanner using sonar-project.properties (no need to re-declare properties)
            sonar-scanner -Dsonar.token=$SONAR_TOKEN
            ''' 
            }
        }
        
        stage('Security stage') {
            steps {
                echo 'Automated security analysis on dependencies of the application using Snyk'
                sh '''
                pip install -r requirements.txt
                npm install -g snyk
                snyk auth $SNYK_TOKEN
                # Run snyk test but don't exit on vulnerabilities
                snyk test || true
    
                # Try to auto-fix vulnerabilities
                pip install --upgrade pip pip-review
                # Upgrade all dependencies to the latest version that resolves vulnerabilities
                pip-review --auto || true

                # Re-install dependencies to ensure everything is correctly updated
                pip install -r requirements.txt
                
                # Test again
                snyk test
                '''
            }
       }
       
       stage('Deploy stage') {
           steps{
                echo 'Deploy application using Docker Compose'
                sh '''docker compose up -d'''
           }
       }
       
       stage('Release stage') {
           steps{
                echo 'Release application using Azure Kubernetes Service'
                sh '''bash script/azure_script.sh'''
           }
       }

       stage('Monitoring and Alerting stage') {
           steps{
                echo 'Monitor application using Azure Monitor and New Relic'
                sh '''bash script/monitoring_alert.sh'''
                sh '''bash script/newrelic_monitoring.sh'''
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
