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