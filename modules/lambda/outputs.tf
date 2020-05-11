output "name" {
  value = "${var.function_name}"
}

output "arn" {
  value "${aws_lambda_function.lambda.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.lambda.invoke_arn}"
}

output "version" {
  value = "${aws_lambda_function.lambda.version}"
}
