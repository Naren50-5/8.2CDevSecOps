pipeline {
    agent any

    environment {
        // Set your SonarCloud token as a Jenkins secret
        SONAR_TOKEN = credentials('SONAR_TOKEN')  
    }

    tools {
        nodejs "NodeJS"     // Make sure NodeJS is configured in Jenkins Global Tool Configuration
        jdk "Java17"        // Make sure Java17 is configured in Jenkins Global Tool Configuration
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Run SonarCloud Scan') {
            steps {
                script {
                    // Fetch Java 17 path from Jenkins tool
                    def javaHome = tool name: 'Java17', type: 'jdk'

                    withEnv([
                        "JAVA_HOME=${javaHome}",
                        "PATH=${javaHome}/bin:${env.PATH}"
                    ]) {
                        sh '''
                            echo "Using Java version:"
                            java -version

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

    }

    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }

        success {
            echo 'Build, test, and SonarCloud scan succeeded!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
