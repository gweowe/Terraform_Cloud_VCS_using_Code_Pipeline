resource "aws_iam_role" "codebuild_role" {
  name = var.codebuild_role_name
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
           "Effect": "Allow",
           "Principal": {
              "Service": "codebuild.amazonaws.com"
           },
           "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  description = var.codebuild_policy_name
  policy      = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents",
          "ecr:GetAuthorizationToken"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.code_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}


resource "aws_iam_role" "codepipeline_role" {
  name = var.codepipeline_role_name
  assume_role_policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  description = var.codepipeline_policy_name
  policy      = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject",
          "s3:GetBucketVersioning"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.code_bucket.arn}/*"
      },
      {
        "Action" : [
          "codebuild:StartBuild", "codebuild:BatchGetBuilds",
          "iam:PassRole"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action" : [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive"
        ],
        "Effect": "Allow",
        "Resource": "${aws_codecommit_repository.codecommit_repository.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

resource "aws_iam_role" "cloudwatch_role" {
  name_prefix = var.cloudwatch_role_name

  assume_role_policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
})
}

data "aws_iam_policy_document" "cloudwatch_iam_copy_policy" {
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = [
      aws_codepipeline.code_pipeline.arn
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_iam_policy" {
  name_prefix = var.cloudwatch_policy_name
  policy = data.aws_iam_policy_document.cloudwatch_iam_copy_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  policy_arn = aws_iam_policy.cloudwatch_iam_policy.arn
  role = aws_iam_role.cloudwatch_role.name
}
