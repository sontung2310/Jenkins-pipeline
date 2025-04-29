pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/sontung2310/Jenkins-pipeline.git'
            }
        }
        stage('Build stage') {
            steps {
                echo 'Build Docker image for Flask application'
                sh 'docker build -t flask-auth-app:latest .'
            }
        }

        stage('Test stage') {
            steps {
                echo 'Run unit tests using pytest'
                sh 'docker run --rm flask-auth-app:latest pytest'
            }
        }
        
        stage('Code quality analysis stage') {
            environment {
                SONAR_TOKEN = credentials('SONAR_TOKEN')
            }
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
            environment {
                SNYK_TOKEN = credentials('Snyk-api-token')
                SNYK_CFG_ENABLE_FIX = 'true'
            }
            steps {
                echo 'Automated security analysis on dependencies of the application using Snyk'
                sh '''
                pip install -r requirements.txt
                npm install -g snyk
                snyk auth $SNYK_TOKEN
                # Run snyk test but don't exit on vulnerabilities
                snyk test || echo "Snyk test found issues, continuing to fix..."
    
                # Try to auto-fix vulnerabilities
                pip install --upgrade pip pip-review
                # Upgrade all dependencies to the latest version that resolves vulnerabilities
                pip-review --auto

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
                sh '''bash azure_script.sh'''
           }
       }

       stage('Monitoring and Alerting stage') {
           steps{
                echo 'Monitor application using Azure Monitor'
                sh '''bash monitoring_script.sh'''
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
