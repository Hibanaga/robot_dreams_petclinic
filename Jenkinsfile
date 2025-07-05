pipeline {
    agent any

    environment {
        EC2_USER = 'ec2-user'
        EC2_HOST = '51.20.190.194'
        SSH_KEY_ID = 'ec2-ssh-key'
        DEPLOY_DIR = '/home/ec2-user/app'
        JAR_NAME = 'spring-boot-complete-0.0.1-SNAPSHOT.jar'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Hibanaga/gs-spring-boot.git'
                script {
                    env.GIT_BRANCH = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -f complete/pom.xml clean package'
            }
        }

        stage('Deploy') {
            steps {
                sshagent (credentials: [env.SSH_KEY_ID]) {
                    sh """
                        mkdir -p ~/.ssh
                        ssh-keyscan -H ${EC2_HOST} >> ~/.ssh/known_hosts

                        scp complete/target/${JAR_NAME} ${EC2_USER}@${EC2_HOST}:${DEPLOY_DIR}/${JAR_NAME}
                        ssh ${EC2_USER}@${EC2_HOST} "chmod +x ~/deploy.sh && ~/deploy.sh"
                    """
                }
            }
        }
    }
}