pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN')  // Jenkins secret
    }

    tools {
        jdk "Java17"
        nodejs "NodeJS"
    }

    stages {
        stage('SonarCloud Scan') {
            steps {
                script {
                    def javaHome = tool name: 'Java17', type: 'jdk'
                    withEnv(["JAVA_HOME=${javaHome}", "PATH=${javaHome}/bin:${env.PATH}"]) {
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
    }
}
