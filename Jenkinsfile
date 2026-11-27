pipeline {
  agent any

  environment {
    // REPLACE THESE WITH THE PATHS YOU JUST FOUND
    // Example: "C:\\Program Files\\Docker\\Docker\\resources\\bin\\docker.exe"
    DOCKER_CMD = "YOUR_DOCKER_PATH" 
    BASH_CMD   = "YOUR_BASH_PATH"
    
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
        // Using the exact path for Docker
        bat '"%DOCKER_CMD%" run --rm -v "%cd%":/app -w /app python:3.12-slim sh -c "pip install -q ruff && ruff check app"'
      }
    }

    stage('Build Image') {
      steps { bat '"%BASH_CMD%" scripts/build.sh' }
    }

    stage('Unit Test') {
      steps { bat '"%BASH_CMD%" scripts/test.sh' }
      post { always { junit allowEmptyResults: true, testResults: 'reports/junit.xml' } }
    }

    stage('Run Container') {
      steps { bat '"%BASH_CMD%" scripts/run.sh' }
    }

    stage('Carbon Gate') {
      steps { bat '"%BASH_CMD%" scripts/gate.sh' }
    }

    stage('Deploy') {
      steps { bat '"%BASH_CMD%" scripts/deploy.sh' }
    }

    stage('Smoke Test') {
      steps { bat '"%BASH_CMD%" scripts/smoke.sh' }
    }
  }

  post {
    always {
      bat '"%DOCKER_CMD%" rm -f greengate-ci || exit 0'
    }
    success { echo '✅ Pipeline succeeded — deploy approved' }
    failure { echo '❌ Pipeline failed — check the Carbon Gate stage' }
  }
}