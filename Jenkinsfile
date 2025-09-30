pipeline {
    agent any

    tools {
        nodejs "NodeJS"       
        jdk "Java17"         
    }

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN')   
        SNYK_TOKEN  = credentials('SNYK_TOKEN')    
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                script {
                    
                    try {
                        sh 'echo $SNYK_TOKEN'
                        sh 'snyk auth $SNYK_TOKEN'
                        sh 'snyk test --all-projects || true'
                    } catch(Exception e) {
                        echo "Snyk scan failed, continuing pipeline..."
                    }
                }
            }
        }

        stage('SonarCloud Scan') {
            steps {
                script {
                    try {
                        sh '''
                        npx sonar-scanner \
                            -Dsonar.projectKey=Naren50-5_8.2CDevSecOps \
                            -Dsonar.organization=Naren50-5 \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=node_modules/**,test/** \
                            -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN || true
                        '''
                    } catch(Exception e) {
                        echo "SonarCloud scan failed, continuing pipeline..."
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}
