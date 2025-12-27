pipeline{
    agent {
        docker {
            image 'docker:24'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

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
                sh 'docker exec ci-test curl -f http://localhost:8000/'
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