pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
        timestamps()
    }
    environment {
        GIT_URL  = 'https://github.com/Naren50-5/8.2CDevSecOps.git'
        EMAIL_TO = 'narenrajkumar1984@gmail.com'
        NPM_CONFIG_CACHE = "${WORKSPACE}/npm-cache"
    }

    stages {

        stage('Checkout (shallow)') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: env.GIT_URL]],
                    extensions: [[$class: 'CloneOption', shallow: true, depth: 1, noTags: true]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci --no-audit --no-fund'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test > test.log 2>&1 || true'   // Don't fail on errors
                archiveArtifacts artifacts: 'test.log', allowEmptyArchive: true
                emailext(
                    subject: "Tests for ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    to: "${env.EMAIL_TO}",
                    body: "Tests finished. See attached test.log",
                    attachmentsPattern: 'test.log'
                )
            }
        }

        stage('NPM Audit (Security Scan)') {
            steps {
                sh 'npm audit --json > npm_audit.json || true'  // Don't fail on vulnerabilities
                archiveArtifacts artifacts: 'npm_audit.json', allowEmptyArchive: true
                emailext(
                    subject: "NPM Audit for ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    to: "${env.EMAIL_TO}",
                    body: "NPM audit finished. See attached npm_audit.json",
                    attachmentsPattern: 'npm_audit.json'
                )
            }
        }
    }

    post {
        always {
            emailext(
                subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                to: "${env.EMAIL_TO}",
                body: """Build result: ${currentBuild.currentResult}
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
URL: ${env.BUILD_URL}""",
                attachLog: true,
                compressLog: true
            )
        }
    }
}
