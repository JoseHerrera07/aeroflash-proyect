pipeline {
    agent none
    stages {
        stage('Backend Build') {
            agent {
                docker { image 'python:3.12-slim' }
            }
            steps {
                dir('flight-booking-app/backend') {
                    sh 'pip install -r requirements.txt'
                    sh 'python -m compileall .'
                }
            }
        }
        stage('Frontend Build') {
            agent {
                docker { image 'node:18-alpine' }
            }
            steps {
                dir('flight-booking-app/frontend') {
                    sh 'echo "Simulando build de Angular..."'
                }
            }
        }
    }
}
