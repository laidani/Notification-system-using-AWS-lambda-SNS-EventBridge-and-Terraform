resource "aws_cloudwatch_event_rule" "invoke_lambda_rule" {
  name                = "invoke_lambda_rule"
  description         = "Invoke lambda rule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "event_rule_target" {
  rule = aws_cloudwatch_event_rule.invoke_lambda_rule.name
  arn  = aws_lambda_function.gold_price_checker_lambda.arn
}

resource "aws_lambda_permission" "allow_event_bridge_to_call_lambda" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gold_price_checker_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.invoke_lambda_rule.arn
}