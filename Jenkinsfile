pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN')  // Make sure you've added your token in Jenkins credentials
    }

    tools {
        jdk 'Java17'         // Predefined Java 17 installation in Jenkins
        nodejs 'NodeJS'      // Predefined NodeJS installation in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Naren50-5/8.2CDevSecOps.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                nodejs('NodeJS') {
                    sh 'npm ci'   // Clean install all dependencies
                }
            }
        }

        stage('Run Tests') {
            steps {
                nodejs('NodeJS') {
                    sh 'npm test -- --coverage'
                }
            }
        }

        stage('SonarCloud Scan') {
            steps {
                nodejs('NodeJS') {
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

    post {
        always {
            archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
            junit 'test-results/**/*.xml'  // if your tests generate JUnit XML results
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
