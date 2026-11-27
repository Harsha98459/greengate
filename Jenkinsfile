pipeline {
  agent any

  environment {
    IMAGE     = "greengate"
    TAG       = "${env.BUILD_NUMBER}"
    CONTAINER = "greengate-ci"
    THRESHOLD = "1000" 
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Checkout') {
      steps { bat 'git rev-parse --short HEAD' }
    }

    stage('Lint') {
      steps {
        bat 'docker run --rm -v "%cd%":/app -w /app python:3.12-slim sh -c "pip install -q ruff && ruff check app"'
      }
    }

    stage('Build Image') {
      steps { bat 'bash scripts/build.sh' }
    }

    stage('Unit Test') {
      steps { bat 'bash scripts/test.sh' }
      post { always { junit allowEmptyResults: true, testResults: 'reports/junit.xml' } }
    }

    stage('Run Container') {
      steps { bat 'bash scripts/run.sh' }
    }

    stage('Carbon Gate') {
      steps { bat 'bash scripts/gate.sh' }
    }

    stage('Deploy') {
      steps { bat 'bash scripts/deploy.sh' }
    }

    stage('Smoke Test') {
      steps { bat 'bash scripts/smoke.sh' }
    }
  }

  post {
    always {
      bat 'docker rm -f greengate-ci || exit 0'
    }
    success { echo '✅ Pipeline succeeded — deploy approved' }
    failure { echo '❌ Pipeline failed — check the Carbon Gate stage' }
  }
}