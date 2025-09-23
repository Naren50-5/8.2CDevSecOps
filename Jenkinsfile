pipeline {
    agent any

    tools {
        jdk "Java17"        // Jenkins JDK tool name
        nodejs "NodeJS"     // Jenkins NodeJS tool name
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Use Jenkins credentials ID for SonarCloud token
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naren50-5/8.2CDevSecOps.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test -- --coverage'
            }
        }

        stage('SonarCloud Scan') {
            steps {
                sh """
                npx sonar-scanner \
                    -Dsonar.projectKey=Naren50-5_8.2CDevSecOps \
                    -Dsonar.organization=Naren50-5 \
                    -Dsonar.sources=. \
                    -Dsonar.exclusions=node_modules/**,test/** \
                    -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                    -Dsonar.host.url=https://sonarcloud.io \
                    -Dsonar.login=$SONAR_TOKEN
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
