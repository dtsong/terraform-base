resource "aws_cloudwatch_log_group" "log_group" {
  name = "/${var.log_stream_name}/${var.log_group_name}"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.log_stream_name}"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
}
