resource "aws_cloudwatch_event_rule" "codecommit_activity" {
  name_prefix = var.cloudwatch_codecommit_name

  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "resources": [ "${aws_codecommit_repository.codecommit_repository.arn}" ],
  "detail": {
     "event": [
       "referenceCreated",
       "referenceUpdated"
      ],
     "referenceType":["branch"],
     "referenceName": ["${var.repository_branch}"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "cloudwatch_trigger" {
  target_id = var.cloudwatch_trigger_name
  rule = aws_cloudwatch_event_rule.codecommit_activity.name
  arn = aws_codepipeline.code_pipeline.arn
  role_arn = aws_iam_role.cloudwatch_role.arn
}

