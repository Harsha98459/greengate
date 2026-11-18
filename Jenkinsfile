pipeline {
  agent any

  environment {
    IMAGE     = "greengate"
    TAG       = "${env.BUILD_NUMBER}"
    CONTAINER = "greengate-ci"
    THRESHOLD = "1000"          // relaxed for demo; set 50 to watch the gate FAIL
    REGISTRY  = "docker.io/YOUR_DOCKERHUB_USER"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  stages {
    stage('Checkout') {
      steps { sh 'git rev-parse --short HEAD && git log -1 --pretty=%s' }
    }

    stage('Lint') {
      steps {
        sh 'docker run --rm -v "$PWD":/app -w /app python:3.12-slim sh -c "pip install -q ruff && ruff check app"'
      }
    }

    stage('Build Image') {
      steps { sh './scripts/build.sh' }
    }

    stage('Unit Test') {
      steps { sh './scripts/test.sh' }
      post { always { junit allowEmptyResults: true, testResults: 'reports/junit.xml' } }
    }

    stage('Run Container') {
      steps { sh './scripts/run.sh' }
    }

    stage('Carbon Gate') {
      steps { sh './scripts/gate.sh' }
    }

    stage('Push Image') {
      when { branch 'main' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                          usernameVariable: 'DOCKER_USER',
                          passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh './scripts/push.sh'
        }
      }
    }

    stage('Deploy') {
      when { branch 'main' }
      steps { sh './scripts/deploy.sh' }
    }

    stage('Smoke Test') {
      steps { sh './scripts/smoke.sh' }
    }
  }

  post {
    always {
      sh 'docker rm -f greengate-ci || true'
    }
    success { echo '✅ Pipeline succeeded — deploy approved' }
    failure { echo '❌ Pipeline failed — check the Carbon Gate stage' }
  }
}
