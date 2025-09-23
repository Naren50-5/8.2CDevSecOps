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

        // Stage 6: SonarCloud Analysis
        stage('SonarCloud Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        set -e
                        echo "Downloading SonarScanner..."
                        wget -qO sonar-scanner.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip"
                        unzip -q sonar-scanner.zip
                        echo "Running SonarScanner..."
                        ./sonar-scanner-*/bin/sonar-scanner -Dsonar.login=$SONAR_TOKEN
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
