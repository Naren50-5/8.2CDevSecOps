pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Make sure this is configured in Jenkins credentials
    }
    stages {
        stage('Install Dependencies') {
            tools {
                nodejs "NodeJS"
            }
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            tools {
                nodejs "NodeJS"
            }
            steps {
                sh 'npm test -- --coverage'
            }
        }

        stage('SonarCloud Scan') {
            tools {
                java "Java17"
                nodejs "NodeJS"
            }
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
}
