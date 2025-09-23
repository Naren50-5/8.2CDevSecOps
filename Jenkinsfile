pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Jenkins secret token ID
    }
    stages {
        // Stage 1: Checkout
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naren50-5/8.2CDevSecOps.git'
            }
        }

        // Stage 2: Install Dependencies
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
                sh 'npm install --save-dev sonar-scanner'
            }
        }

        // Stage 3: Run Tests
        stage('Run Tests') {
            steps {
                sh 'npm test || true'
            }
        }

        // Stage 4: Generate Coverage Report
        stage('Generate Coverage Report') {
            steps {
                sh 'npm run coverage || true'
            }
        }

        // Stage 5: NPM Audit (Security Scan)
        stage('NPM Audit') {
            steps {
                sh 'npm audit || true'
            }
        }

        // Stage 6: SonarCloud Analysis using npm SonarScanner
        stage('SonarCloud Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
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
    }
    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
