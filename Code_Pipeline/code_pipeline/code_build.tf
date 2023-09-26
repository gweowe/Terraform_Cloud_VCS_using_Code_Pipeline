resource "aws_codebuild_project" "codebuild" {
  name         = var.codebuild_name
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image = "hashicorp/terraform"
    type = "LINUX_CONTAINER"
    privileged_mode = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name = "TF_TOKEN_app_terraform_io"
      value = var.tfc_token
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = <<EOF
${file("${path.module}/buildspec.yml")}
    EOF
  }
}