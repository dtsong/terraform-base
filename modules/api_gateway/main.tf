resource "aws_api_gateway_rest_api" "api_gateway" {
  name   = "${local.gateway_name}"
  body   = "${var.authorizer_uri == "NOT_SET" ? local.formatted_uri_swagger : local.formatted_authuri_swagger}"
  policy = "${var.authorizer_uri == "NOT_SET" ? data.aws_iam_policy_document.json : ""}"
}
resource "aws_api_gateway_stage" "gateway_stage" {
  stage_name            = "${var.stage_name}"
  rest_api_id           = "${aws_api_gateway_rest_api.api_gateway.id}"
  deployment_id         = "${aws_api_gateway_deployment.gateway_deploy.id}"
  cache_cluster_enabled = "${var.cache_enabled}"
  cache_cluster_size    = "${var.cache_cluster_size}"

  tags {
    Resource = "api_gateway"
    Owner    = "dtsong"
  }

  depends_on = ["aws_api_gateway_deployment.gateway_deploy"]
}

resource "aws_api_gateway_deployment" "gateway_deploy" {
  rest_api_id       = "${aws_api_gateway_rest_api.api_gateway.id}"
  stage_name        = ""
  stage_description = "${md5(local.formatted_uri_swagger)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "${local.invoke_statement_id}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.gateway_deploy.execution_arn}*"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_api_gateway_stage.gateway_stage"]
}

resource "aws_lambda_permission" "auth_lambda_permission" {
  count         = "${var.lambda_authorizer_name == "NOT_SET" ? 0 : 1}"
  statement_id  = "${local.auth_invoke_statement_id}"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_authorizer_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.gateway_deploy.execution_arn}*"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_api_gateway_stage.gateway_stage"]
}
