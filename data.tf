data "aws_ami" "stack_ami" {
  owners     = ["self"]
  name_regex = "^ami-stack-.*"
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-stack*"]
  }
}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "creds"
 }

# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

data "aws_ecr_repository" "ecr_repository" {
  name = "clixx-repository"
  registry_id = 381492048000

}

