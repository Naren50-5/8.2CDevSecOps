pipeline {
    agent any

    environment {
        EMAIL_RECIPIENT = "narenrajkumar1984@gmail.com"
    }

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
                // Run tests, fail build if tests fail
                sh '''
                    npm test 2>&1 | tee test-output.log
                    TEST_EXIT_CODE=${PIPESTATUS[0]}
                    exit $TEST_EXIT_CODE
                '''
                archiveArtifacts artifacts: 'test-output.log', allowEmptyArchive: true
            }
        }

        stage('Generate Coverage Report') {
            steps {
                sh 'npm run coverage || true'
            }
        }

        stage('NPM Audit (Security Scan)') {
            steps {
                sh '''
                    npm audit 2>&1 | tee npm-audit-output.log || true
                '''
                archiveArtifacts artifacts: 'npm-audit-output.log', allowEmptyArchive: true
            }
        }

        stage('Snyk Security Scan') {
            steps {
                sh '''
                    snyk code test 2>&1 | tee snyk-output.log || true
                '''
                archiveArtifacts artifacts: 'snyk-output.log', allowEmptyArchive: true
            }
        }
    }

    post {
        always {
            echo "Sending email to ${env.EMAIL_RECIPIENT} with logs..."
            emailext (
                subject: "Jenkins Pipeline: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
                body: """
                    <p>Hello,</p>
                    <p>Your Jenkins pipeline has completed.</p>
                    <p><b>Build Status:</b> ${currentBuild.currentResult}</p>
                    <p>Full console output: 
                        <a href="${env.BUILD_URL}console">${env.BUILD_URL}console</a>
                    </p>
                    <p>Relevant logs are attached:</p>
                    <ul>
                        <li>Test Output: test-output.log</li>
                        <li>NPM Audit: npm-audit-output.log</li>
                        <li>Snyk Scan: snyk-output.log</li>
                    </ul>
                """,
                to: "${env.EMAIL_RECIPIENT}",
                mimeType: 'text/html',
                attachmentsPattern: "test-output.log,npm-audit-output.log,snyk-output.log"
            )
        }
    }
}
