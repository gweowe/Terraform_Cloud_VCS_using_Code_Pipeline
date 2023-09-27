resource "aws_codepipeline" "code_pipeline" {
  name     = var.codepipline_name
  role_arn = aws_iam_role.codepipeline_role.arn
  
  artifact_store {
    location = aws_s3_bucket.code_bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      output_artifacts = ["SourceOutput"]
      run_order        = 1
      configuration = {
        RepositoryName = aws_codecommit_repository.codecommit_repository.repository_name
        BranchName = "${var.repository_branch}"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }
}

resource "aws_s3_bucket" "code_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}
