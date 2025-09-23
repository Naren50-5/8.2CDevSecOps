pipeline {
    agent any

    tools {
        nodejs "NodeJS"   // match NodeJS tool name in Jenkins
        jdk "Java17"      // match Java17 tool name in Jenkins
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN')
        SNYK_TOKEN  = credentials('SNYK_TOKEN')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Naren50-5/8.2CDevSecOps.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install --legacy-peer-deps'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test -- --coverage --verbose || true'
            }
        }

        stage('Snyk Scan') {
            steps {
                sh '''
                export SNYK_TOKEN=$SNYK_TOKEN
                snyk auth $SNYK_TOKEN
                snyk test --all-projects
                '''
            }
        }

        stage('SonarCloud Scan') {
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
            archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
            junit 'test-results/**/*.xml'  // if your tests output JUnit XML
        }
    }
}
