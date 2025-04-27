pipeline{
    agent any
    stages{
        sh 'cd /Users/sontung/Desktop/3.Project/trimester_3/SIT753_HD'

        stage('Build'){
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