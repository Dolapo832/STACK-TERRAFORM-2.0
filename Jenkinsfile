pipeline {
    agent any
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        ACTION = "destroy"
        RUNNER = "Dolapo"
    }
      stages{
        stage('Initial Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }
         stage('terraform init'){
             steps {
                slackSend (color: '#FFFF00', message: "STARTED init: Job by ${RUNNER}' ${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                sh "terraform init"
             }
         }
         stage('terraform plan'){
            steps {
                slackSend (color: '#FFFF00', message: "STARTED plan: Job by ${RUNNER}' ${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                sh "terraform plan -out=tfplan -input=false"
            }
        }
         stage('Final Deployment Approval') {
            steps {
                slackSend (color: '#FFFF00', message: "STARTED Approval: Job by ${RUNNER}' ${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                script {
                    def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: true, description: 'Apply terraform', name: 'confirm'] ])
                }
            }
         }
         stage('Terraform Final Action'){
            steps {
                slackSend (color: '#FFFF00', message: "STARTED Final Action: Job by ${RUNNER}' ${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                script{stage("Performing Terraform ${ACTION}")}
                sh "terraform ${ACTION} --auto-approve"
                //  sh "terraform apply  -input=false tfplan"
            }
        }
        // stage('Terraform Destroy'){
        //     steps {
        //          sh "terraform destroy -auto-approve"
        //     }
        // }
    }
}
def getTerraformPath(){
        def tfHome= tool name: 'terraform-40', type: 'terraform'
        return tfHome
    }