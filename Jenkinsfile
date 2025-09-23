pipeline {
    agent any

    tools {
        nodejs 'NodeJS'      // NodeJS installation name in Jenkins
        jdk 'Java17'         // JDK 17 installation name in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // your SonarCloud token
    }

    stages {
        stage('Verify Tools') {
            steps {
                sh 'java -version'
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
                sh 'ls -la node_modules'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test -- --coverage --verbose'
            }
        }

        stage('SonarCloud Scan') {
            steps {
                sh 'ls -la coverage'  // Verify lcov.info exists
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
            junit '**/test-results/**/*.xml' // If you generate junit xml reports
        }
        success {
            echo 'Pipeline finished successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
