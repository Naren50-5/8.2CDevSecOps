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
        // Run tests, capture output to test.log, force success so pipeline continues
        sh 'npm test > test.log 2>&1 || true'
        archiveArtifacts artifacts: 'test.log', allowEmptyArchive: true
      }
      post {
        always {
          emailext(
            subject: "Run Tests - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            to: env.EMAIL_TO,
            body: "Stage Run Tests finished. See attached test.log",
            attachmentsPattern: 'test.log'
          )
        }
      }
    }

    stage('Quick Security Audit') {
      steps {
        // Run npm audit, capture output to audit.json, force success so pipeline continues
        sh 'npm audit --omit=dev --json > audit.json || true'
        archiveArtifacts artifacts: 'audit.json', allowEmptyArchive: true
      }
      post {
        always {
          emailext(
            subject: "Security Audit - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            to: env.EMAIL_TO,
            body: "Stage Quick Security Audit finished. See attached audit.json",
            attachmentsPattern: 'audit.json'
          )
        }
      }
    }
  }

  post {
    always {
      // Final wrap-up email with full build info and logs attached
      archiveArtifacts allowEmptyArchive: true, artifacts: 'audit.json,test.log'
      emailext(
        subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        to: env.EMAIL_TO,
        body: """Build result: ${currentBuild.currentResult}
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
URL: ${env.BUILD_URL}

Attached are the test and audit logs.""",
        attachmentsPattern: 'test.log,audit.json'
      )
    }
  }
}
