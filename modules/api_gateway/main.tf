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

resource "aws_api_gateway_method_settings" "aws_api_gateway_cache_enabled" {
  count       = "${var.cache_enabled == "false" ? 0 : 1}"
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway_id}"
  stage_name  = "${var.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
  }

  depends_on = ["aws_api_gateway_stage.gateway_stage"]
}

resource "aws_api_gateway_method_settings" "aws_api_gateway_default" {
  count       = "${var.cache_enabled == "true" ? 0 : 1}"
  rest_api_id = "${aws_api_gateway_rest_api.api_gateway.id}"
  stage_name  = "${var.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
  }

  depends_on = ["aws_api_gateway_stage.gateway_stage"]
}

resource "aws_api_gateway_base_path_mapping" "mapping" {
  count       = "${var.domain_name = "NOTSET" ? 0 : 1}"
  stage_name  = "${var.stage_name}"
  api_id      = "${aws_api_gateway_rest_api.api_gateway.id}"
  domain_name = "${var.domain_name}"

  depends_on = ["aws_api_gateway_domain_name.name"]
}

resource "aws_api_gateway_domain_name" "name" {
  count                    = "${var.domain_name == "NOTSET" ? 0 : 1}"
  regional_certificate_arn = "${var.certificate_arn}"
  domain_name              = "${var.domain_name}"
  security_policy          = "${var.api_gateway_security_policy}"

  endpoint_configuration {
    types = "${var.api_gateway_endpoint_configuration_types}"
  }
}

resource "aws_route53_record" "domain_name" {
  count           = "${var.domain_name == "NOTSET" ? 0 : 1}"
  zone_id         = "${var.domain_zone_id}"
  name            = "${var.domain_name}"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = "${aws_api_gateway_domain_name.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.regional_zone_id}"
    evaluate_target_health = false
  }
}
