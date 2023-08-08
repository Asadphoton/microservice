pipeline {
	agent {
		label 'linux_build'
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
					sh "mvn clean install"
				}
			}
		}
		stage("Compile Docker Image") {
			steps {
				script{
					sh "echo compliation"
					sh "sudo docker build -t aadav/microservice:${BUILD_ID} ."
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
					return env['GIT_BRANCH'].contains('master')
				}
			}
			steps {
				script {
					sh "echo publish"
					sh "sudo docker login --username aadav --password Aadav321"
					sh "sudo docker push aadav/microservice:${BUILD_ID}"
				}
			}
		}
		stage('Deploy to SIT') {
			when {
				expression {
					return env['GIT_BRANCH'].contains('master')
				}
			}
			steps {
				script {
					sh "echo Deploy to SIT"
					sh "sh /home/ec2-user/configure_awscli.sh"
					build job: "microservice_deploy", parameters: [string(name: 'TAG', value: "${BUILD_ID}")],wait: true
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

