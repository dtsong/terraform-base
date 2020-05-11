resource "aws_cloudwatch_event_rule" "rule" {
  name = "${var.name}"

  schedule_expression = "${var.schedule}"

  tags = {
    Resource = "cloudwatch_event_rule"
    Owner    = "dtsong"
  }
}

resource "aws_cloudwatch_event_target" "target" {
  rule = "${aws_cloudwatch_event_rule.rule.name}"
  arn  = "${var.event_target_arn}"
}
