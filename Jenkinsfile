#!groovy

pipeline {
    agent { label 'ubuntu16' }

    stages {
        stage('Build') {
            steps {
                dockerBuildTagPush("prod volunteer stage".split())
            }
        }
    }
}
