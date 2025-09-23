pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Naren50-5/8.2CDevSecOps.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                // Capture test output into test.log
                sh 'npm test > test.log 2>&1 || true'
            }
            post {
                always {
                    // Archive test log
                    archiveArtifacts artifacts: 'test.log', allowEmptyArchive: true

                    // Email the test log
                    emailext (
                        to: 'narenrajkumar1984@gmail.com',
                        subject: "Tests for ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${currentBuild.currentResult ?: "SUCCESS"}",
                        body: """Hello,

Tests have completed for job *${env.JOB_NAME}* build *#${env.BUILD_NUMBER}*.

You can download test.log from Jenkins or see it attached.

Regards,
Jenkins CI/CD
""",
                        attachmentsPattern: 'test.log'
                    )
                }
            }
        }

        stage('Generate Coverage Report') {
            steps {
                sh 'npm run coverage > coverage.log 2>&1 || true'
            }
            post {
                always {
                    // Archive coverage log and coverage folder
                    archiveArtifacts artifacts: 'coverage.log, coverage/**', allowEmptyArchive: true
                }
            }
        }

        stage('NPM Audit (Security Scan)') {
            steps {
                // Run audit and save JSON
                sh 'npm audit --json > npm_audit.json || true'
            }
            post {
                always {
                    // Archive npm audit JSON
                    archiveArtifacts artifacts: 'npm_audit.json', allowEmptyArchive: true

                    // Email the audit results
                    emailext (
                        to: 'narenrajkumar1984@gmail.com',
                        subject: "NPM Audit for ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                        body: """Hello,

NPM Audit has completed for job *${env.JOB_NAME}* build *#${env.BUILD_NUMBER}*.

The audit results are attached as npm_audit.json.

Regards,
Jenkins CI/CD
""",
                        attachmentsPattern: 'npm_audit.json'
                    )
                }
            }
        }
    }
}
