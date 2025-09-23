pipeline {
    agent any

    environment {
        // Set Java 17 explicitly
        JAVA_HOME = "/opt/homebrew/Cellar/openjdk@17/17.0.16/libexec/openjdk.jdk/Contents/Home"
        PATH = "${JAVA_HOME}/bin:${env.PATH}"

        // SonarCloud authentication token
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Make sure you add this in Jenkins Credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Java Version') {
            steps {
                sh 'java -version'
            }
        }

        stage('Install Dependencies') {
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
        success {
            echo 'SonarCloud scan completed successfully.'
        }
        failure {
            echo 'SonarCloud scan failed.'
        }
    }
}
