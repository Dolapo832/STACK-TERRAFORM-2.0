pipeline {
    agent any
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
    }
    stages{
         stage('terraform init'){
             steps {slackSend (color: '#FFFF00', message: "STARTED: Job 
             '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                 sh "terraform init"
        }
         }
        //  stage('terraform plan'){
        //      steps {
        //          sh "terraform plan"
        //  }
        //  }
        //  stage('terraform destroy'){
        //      steps {
        //          sh "terraform destroy -auto-approve"
        //  }
        //  }
    }
}
def getTerraformPath(){
        def tfHome= tool name: 'terraform-40', type: 'terraform'
        return tfHome
    }