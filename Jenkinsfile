pipeline {
  agent any

  stages {
    stage('Backend - Install') {
      steps {
        dir('cloudtaskpro/backend') {
          sh 'pip install -r requirements.txt'
        }
      }
    }

    stage('Backend - Test') {
      steps {
        sh 'echo "Backend tests placeholder - add pytest or unittest"'
      }
    }

    stage('Docker Build') {
      steps {
        sh 'docker-compose build'
      }
    }
  }
}
