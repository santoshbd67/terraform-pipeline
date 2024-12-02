pipeline {
    agent any
    environment {
        TF_VAR_FILE = "dev.tfvars" // Default environment
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning Terraform configuration repository...'
                git branch: 'main', url: 'https://github.com/santoshbd67/terraform-pipeline.git'
            }
        }

        stage('Select Environment') {
            steps {
                script {
                    // Prompt user for environment selection
                    def userChoice = input(
                        message: 'Select the environment to deploy:',
                        parameters: [
                            choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Select environment')
                        ]
                    )
                    // Set the appropriate tfvars file
                    if (userChoice == "dev") {
                        env.TF_VAR_FILE = "dev.tfvars"
                    } else if (userChoice == "test") {
                        env.TF_VAR_FILE = "test.tfvars"
                    } else if (userChoice == "prod") {
                        env.TF_VAR_FILE = "prod.tfvars"
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                sh "terraform plan -var-file=${TF_VAR_FILE}"
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform changes...'
                sh "terraform apply -var-file=${TF_VAR_FILE} -auto-approve"
            }
        }
    }
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
