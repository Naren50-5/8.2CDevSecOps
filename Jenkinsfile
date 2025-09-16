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
                // Capture test output safely
                sh '''
                    npm test 2>&1 | tee test-output.log || true
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
    }

    post {
        always {
            emailext (
                subject: "Jenkins Pipeline: ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
                body: """<p>Hello,</p>
                         <p>Your Jenkins pipeline has completed.</p>
                         <p><b>Build Status:</b> ${currentBuild.currentResult}</p>
                         <p>You can view the full console output here: 
                            <a href="${env.BUILD_URL}console">${env.BUILD_URL}console</a></p>
                         <p>Relevant logs are attached.</p>""",
                to: "narenadhithya6@gmail.com",
                mimeType: 'text/html',
                attachmentsPattern: "test-output.log,npm-audit-output.log"
            )
        }
    }
}
