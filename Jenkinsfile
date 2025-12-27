pipeline{
    agent any


    stages{
        stage("Checkout"){
            steps{
                checkout scm
                echo "checking out sourcecode"
            }
        }
        stage("Build Docker Image"){
            steps{
                sh 'docker build -t jenkins-ci-api:latest .'
            }
        }
        stage("Run Container"){
            steps{
                sh '''
                    docker run -d -p 8000:8000 --name ci-test jenkins-ci-api:latest
                    sleep 5
                '''
            }
        }
        stage("Health Check"){
            steps{
                sh 'curl -f http://localhost:8000/'
            }
        }
    }
    post{
        always{
            sh 'docker rm -f ci-test || true'
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}