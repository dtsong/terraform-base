resource "aws_lambda_permission" "lambda_exec_permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  principal     = "${var.aws_principal}"
  source_arn    = "${var.soruce_arn}"
}
