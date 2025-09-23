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
    }

    stage('Generate Coverage Report') {
      steps {
        // Save coverage output into a log file too
        sh 'npm run coverage > coverage.log 2>&1 || true'
      }
    }

    stage('NPM Audit (Security Scan)') {
      steps {
        // Human-readable audit to console
        sh 'npm audit || true'
        // Machine-readable audit JSON for archiving
        sh 'npm audit --json > npm_audit.json || true'
      }
    }
  }

  post {
    always {
      // Archive logs and reports so they’re visible/downloadable in Jenkins UI
      archiveArtifacts artifacts: 'test.log, coverage.log, npm_audit.json, coverage/**', allowEmptyArchive: true
    }
  }
}
