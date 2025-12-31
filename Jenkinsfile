pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "jayanth5151/java-app:latest"
    SONARQUBE_ENV = "sonarqube-server"
  }

  stages {

    stage('Checkout') {
      steps {
        git 'https://github.com/jayanth5151/Springboot-end-to-end.git'
      }
    }

    stage('Build & Test') {
      steps {
        sh 'mvn clean verify'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv("${SONARQUBE_ENV}") {
          sh '''
            mvn sonar:sonar \
            -Dsonar.projectKey=java-app \
            -Dsonar.projectName=java-app
          '''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 2, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
            docker login -u $DOCKER_USER -p $DOCKER_PASS
            docker build -t $DOCKER_IMAGE .
            docker push $DOCKER_IMAGE
          '''
        }
      }
    }

    stage('Update K8s Manifests') {
      steps {
        sh '''
          sed -i "s|image:.*|image: $DOCKER_IMAGE|" k8s/deployment.yaml
          git config user.email "jayanth5151@gmail.com"
          git config user.name "jayanth5151"
          git add k8s/deployment.yaml
          git commit -m "Update image to $DOCKER_IMAGE"
          git push origin main
        '''
      }
    }
  }
}
