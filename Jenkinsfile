  pipeline {
    agent any
    environment{  
      scmUrl = "git@github.com:kiranraj4me/AWS_S3_INFRA.git"
      scmBranch = "${env.BRANCH_NAME}" 
      shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'")
      commitId = sh(returnStdout: true, script: "git rev-parse --short HEAD") 
        
          }

      
stages {
        stage('Clear Workspace') {
            steps {
                cleanWs()
                         
            }
        }
        stage('Build') {
         environment{
           branchname = "${env.BRANCH_NAME}"
         }
            steps {
                   dir('source') {
                 
                git branch: scmBranch, credentialsId: '2b6a05fe-7c25-458d-9e5e-60e0d97a61c8', url: scmUrl
               }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                      sh 'whoami && pwd'
                      sh 'ls -ls /var/terraform/s3_website_$scmBranch/'
                      sh 'mv /var/terraform/s3_website_$scmBranch/terraform.tfstate source/'
                      sh 'cd source  && terraform init && terraform plan -var env=$scmBranch && terraform apply -var env=$scmBranch -auto-approve'

            }
        }
        stage('Save') {
            steps {
                echo 'Saving tfstate....'
                      sh 'mkdir -pv /var/terraform/s3_website_$scmBranch'
                      sh 'mv source/terraform.tfstate /var/terraform/s3_website_$scmBranch/'
            }
        }
    }

  }
