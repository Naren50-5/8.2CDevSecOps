pipeline {
    agent any
    tools {
        jdk 'Java17' // Must match the name in Jenkins Global Tool Configuration
    }
    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Your token stored in Jenkins
    }
    stages {
        stage('Run SonarCloud Scan') {
            steps {
                withEnv(["JAVA_HOME=${tool 'Java17'}", "PATH=${tool 'Java17'}/bin:$PATH"]) {
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
