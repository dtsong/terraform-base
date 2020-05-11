output "rule_name" {
  value = "${var.name}"
}

output "arn" {
  value = "${aws_cloudwatch_event_rule.rule.arn}"
}
