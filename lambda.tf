resource "aws_lambda_function" "gold_price_checker_lambda" {
  function_name    = local.function_name
  filename         = local.lambda_file_name
  role             = aws_iam_role.gold_price_checker_lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  timeout          = 60
  source_code_hash = filebase64sha256(local.lambda_file_name)

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.gold_price_checker_sns.arn
    }
  }
}

resource "aws_iam_role" "gold_price_checker_lambda_role" {
  name        = "${local.function_name}-role"
  description = "Role for ${local.function_name}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "gold_price_checker_lambda_policy" {
  name        = "${local.function_name}-policy"
  description = "Policy for ${local.function_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish"
        ],
        "Resource" : aws_sns_topic.gold_price_checker_sns.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.gold_price_checker_lambda_role.name
  policy_arn = aws_iam_policy.gold_price_checker_lambda_policy.arn
}

locals {
  function_name    = "gold_price_checker"
  lambda_file_name = "gold_price_checker.zip"
}