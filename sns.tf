resource "aws_sns_topic" "gold_price_checker_sns" {
  name = "GoldPriceCheckerTopic"
}

resource "aws_sns_topic_subscription" "sms_notification" {
  topic_arn = aws_sns_topic.gold_price_checker_sns.arn
  protocol  = "sms"
  endpoint  = "<PHONE_NUMBER>"
}

resource "aws_sns_topic_subscription" "email_notification" {
  topic_arn = aws_sns_topic.gold_price_checker_sns.arn
  protocol  = "email"
  endpoint  = "<PHONE_NUMBER>"
}