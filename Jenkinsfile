pipeline {
    agent any
    
    environment {
        // Nombre del scanner configurado en tu servidor Jenkins
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
                // 'SonarQubeServer' es el nombre del servidor en la config global de Jenkins
                withSonarQubeEnv('SonarQubeServer') { 
                    sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
                }
            }
        }
        
        stage("Quality Gate Check") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    // Detiene el pipeline si SonarQube encuentra fallas graves
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build & Deploy Simulation') {
            steps {
                echo 'Aquí continúan tus etapas de Docker y despliegue de Terraform...'
            }
        }
    }
}
