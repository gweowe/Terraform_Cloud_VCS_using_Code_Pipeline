#codecommit
variable "codecommit_repository_name" {
  type = string
}

variable "repository_branch" {
  type = string
}

variable "bucket_name" {
  type = string
}

#codebuild
variable "codebuild_name" {
  type = string
}

variable "tfc_token" {
  type = string
}

#codepipeline
variable "codepipline_name" {
  type = string
}

#iam
variable "codebuild_role_name" {
  type = string
}

variable "codebuild_policy_name" {
  type = string
}

variable "codepipeline_role_name" {
  type = string
}

variable "codepipeline_policy_name" {
  type = string
}

variable "cloudwatch_role_name" {
  type = string
}

variable "cloudwatch_policy_name" {
  type = string
}

#cloudwatch
variable "cloudwatch_codecommit_name" {
  type = string
}

variable "cloudwatch_trigger_name" {
  type = string
}
