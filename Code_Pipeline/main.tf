terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "code_pipeline" {
  source = "./code_pipeline"
  count = var.repository_count

  #codecommit
  codecommit_repository_name = "${var.aws_user_name}-${count.index}-codecommit-repository"
  repository_branch = var.repository_branch

  #codebuild
  codebuild_name = "${var.user_name}-${count.index}-codebuild"
  tfc_token = var.tfc_token

  #codepipeline
  codepipline_name = "${var.aws_user_name}-${count.index}-codepipeline"
  bucket_name = "${var.aws_user_name}-${count.index}-bucket"

  #iam
  codebuild_role_name = "${var.aws_user_name}-${count.index}-codebuild-role"
  codebuild_policy_name = "${var.aws_user_name}-${count.index}-codebuild-policy"
  codepipeline_role_name = "${var.aws_user_name}-${count.index}-codepipeline-role"
  codepipeline_policy_name = "${var.aws_user_name}-${count.index}-codepipeline-policy"
}