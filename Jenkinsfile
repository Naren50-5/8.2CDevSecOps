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
        sh 'npm test || true | tee test-output.log'
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
        sh 'npm audit || true | tee npm-audit-output.log'
        archiveArtifacts artifacts: 'npm-audit-output.log', allowEmptyArchive: true
      }
    }
  }

  post {
    always {
      emailext (
        subject: "Build ${env.JOB_NAME} #${env.BUILD_NUMBER} - ${currentBuild.currentResult}",
        body: """Hello,

Your Jenkins pipeline has completed.

Build Status: ${currentBuild.currentResult}

Logs are attached for review.
""",
        to: "narenadhithya6@gmail.com",
        attachmentsPattern: "test-output.log,npm-audit-output.log"
      )
    }
  }
}
