pipeline {
    agent any

    environment {
        SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    bat "${SONAR_SCANNER_HOME}\\bin\\sonar-scanner.bat"
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy Simulation') {
            steps {
                echo 'Aquí continúan las etapas de Docker y Terraform...'
            }
        }
    }
}
