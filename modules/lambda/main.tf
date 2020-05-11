resource "aws_lambda_function" "lambda" {
  filename         = "${var.filename}"
  source_code_hash = "${var.lambda_hash}"
  function_name    = "${var.function_name}"
  role             = "${var.role_arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  publish          = true

  environment {
    variables = "${local.all_env_variables}"
  }

  tags {
    Resource = "lambda"
    Owner    = "dtsong"
    GitHash  = "${local.git_hash}"
  }
}
