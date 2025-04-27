pipeline{
    agent any
    stages{
        # Go to the project directory where the Dockerfile is located
        sh 'cd /Users/sontung/Desktop/3.Project/trimester_3/SIT753_HD'

        stage('Build'){
            # Build Docker image
            steps{
                sh 'docker build -t flask-auth-app:latest .'
            }
        }
        stage('Test'){
            steps{
                echo 'pytest'
            }
        }
        
    }
    post{
        always{
            echo 'Pipeline execution completed.'
        }
        success{
            echo 'Pipeline successed!'
        }
        failure{
            echo 'Pipeline failed!'
        }
    }
}