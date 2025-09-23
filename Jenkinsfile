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
        // If your repo lacks package-lock.json, switch to: npm install --no-audit --no-fund
        sh 'npm ci --no-audit --no-fund'
      }
    }

    stage('Run Tests') {
      steps {
        // Run tests and redirect output to test.log; don't fail pipeline
        sh 'npm test > test.log 2>&1 || true'
        
        // Archive test results
        archiveArtifacts artifacts: 'test.log', allowEmptyArchive: true
        
        // Send email with test results
        emailext(
          subject: "Run Tests: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
          to: env.EMAIL_TO,
          from: 'narenrajkumar1984@gmail.com',
          body: "Stage Run Tests finished. See attached test.log",
          attachmentsPattern: 'test.log'
        )
      }
    }

    stage('Quick Security Audit') {
      steps {
        // Run npm audit and save output to audit.json; don't fail pipeline
        sh 'npm audit --omit=dev --json > audit.json || true'
        
        // Archive audit report
        archiveArtifacts artifacts: 'audit.json', allowEmptyArchive: true
        
        // Send email with audit report
        emailext(
          subject: "Security Audit: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
          to: env.EMAIL_TO,
          from: 'narenrajkumar1984@gmail.com',
          body: "Stage Quick Security Audit finished. See attached audit.json",
          attachmentsPattern: 'audit.json'
        )
      }
    }
  }

  post {
    always {
      archiveArtifacts allowEmptyArchive: true, artifacts: 'audit.json'
      emailext(
        subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        to: env.EMAIL_TO,
        from: 'narenrajkumar1984@gmail.com',
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
