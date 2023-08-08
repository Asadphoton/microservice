pipeline {
	agent {
		label 'slave'
	}
	options{
		buildDiscarder(logRotator(numToKeepStr: '10'))
	}
	environment {
		BUILDSERVER_WORKSPACE = "${WORKSPACE}"
	}

	stages {
		stage('Initialization') {
			steps {
				script {
					sh "echo Initialization"
				}
			}
		}
		stage("Compile Binary") {
			steps {
				script{
					sh "echo compliation"
					sh "mvn clean install -DskipTests=true"
				}
			}
		}
		stage("Compile Docker Image") {
			steps {
				script{
					sh "echo Create docker image"
					sh "sudo docker build -t mohammedasad/microservice:${BUILD_ID} ."
				}
			}
		}
		stage('SonarQube Scan') {
			steps {
				script {
					sh "echo Sonar Scanner"
				}
			}
		}
		stage("Quality Gate") {
			steps {
                                script {
                                        sh "echo Sonar Quality Gate"
                                }
			}
		}
		stage('Publish binary') {
			when {
				expression {
					return env['GIT_BRANCH'].contains('main')
				}
			}
			steps {
				script {
					sh "echo publish"
					sh "sudo docker login --username mohammedasad --password 8143251094@5"
					sh "sudo docker push mohammedasad/microservice:${BUILD_ID}"
				}
			}
		}
		stage('Deploy to SIT') {
			when {
				expression {
					return env['GIT_BRANCH'].contains('main')
				}
			}
			steps {
				script {
					sh "echo Deploy to SIT"
					
				}
			}
		}
	}
	post {
		success{
			script {
				sh "echo Build Success"
			}
		}
		failure {
				sh "echo Build Failed"
		}
		always{
			cleanWs()
		}
	}
}

