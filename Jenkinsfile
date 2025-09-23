pipeline {
    agent any

    // Ensure Jenkins uses the correct JDK from Global Tool Configuration
    tools {
        jdk 'Java17'   // Name of the JDK installation in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Use Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Node Modules') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run SonarCloud Scan') {
            steps {
                sh '''
                    npx sonar-scanner \
                        -Dsonar.projectKey=Naren50-5_8.2CDevSecOps \
                        -Dsonar.organization=Naren50-5 \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**,test/** \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=$SONAR_TOKEN
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "SonarCloud scan completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
