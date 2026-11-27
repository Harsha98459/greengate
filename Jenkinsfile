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
        bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && docker run --rm -v "%cd%":/app -w /app python:3.12-slim sh -c "pip install -q ruff && ruff check app"'
      }
    }

    stage('Build Image') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/build.sh' }
    }

    stage('Unit Test') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/test.sh' }
      post { always { junit allowEmptyResults: true, testResults: 'reports/junit.xml' } }
    }

    stage('Run Container') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/run.sh' }
    }

    stage('Carbon Gate') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/gate.sh' }
    }

    stage('Deploy') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/deploy.sh' }
    }

    stage('Smoke Test') {
      steps { bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && "C:\\Program Files\\Git\\bin\\bash.exe" scripts/smoke.sh' }
    }
  }

  post {
    always {
      bat 'set "PATH=%PATH%;C:\\Users\\blhar\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin" && docker rm -f greengate-ci || exit 0'
    }
    success { echo '✅ Pipeline succeeded — deploy approved' }
    failure { echo '❌ Pipeline failed — check the Carbon Gate stage' }
  }
}