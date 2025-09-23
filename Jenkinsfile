pipeline {
    agent any
    environment {
        // Jenkins credential ID for SonarCloud token
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }
    stages {
        // Stage 1: Checkout
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your_github_username/8.2CDevSecOps.git'
            }
        }

        // Stage 2: Install Dependencies (Build)
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        // Stage 3: Run Unit and Integration Tests
        stage('Run Tests') {
            steps {
                sh 'npm test > test.log 2>&1 || true'
                archiveArtifacts artifacts: 'test.log', allowEmptyArchive: true
            }
        }

        // Stage 4: Generate Coverage Report
        stage('Generate Coverage Report') {
            steps {
                sh 'npm run coverage || true'
                archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
            }
        }

        // Stage 5: NPM Audit (Security Scan)
        stage('NPM Audit') {
            steps {
                sh 'npm audit --json > npm_audit.json || true'
                archiveArtifacts artifacts: 'npm_audit.json', allowEmptyArchive: true
            }
        }

        // Stage 6: SonarCloud Analysis
        stage('SonarCloud Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        set -e
                        echo "Downloading SonarScanner..."
                        wget -qO sonar-scanner.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip"
                        unzip -q sonar-scanner.zip
                        echo "Running SonarScanner..."
                        ./sonar-scanner-*/bin/sonar-scanner -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        // Stage 7: Optional Deployment to Staging (placeholder)
        stage('Deploy to Staging') {
            steps {
                echo 'Deploy to staging (e.g., SSH, Docker, or Ansible)'
            }
        }

        // Stage 8: Integration Tests on Staging (placeholder)
        stage('Integration Tests on Staging') {
            steps {
                echo 'Run integration tests on staging environment'
            }
        }

        // Stage 9: Deploy to Production (placeholder)
        stage('Deploy to Production') {
            steps {
                echo 'Deploy to production server'
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
