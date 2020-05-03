variable "region" {}
variable "account_id" {}
variable "function_name" {}
variable "swagger_api_file" {}
variable "invoke_arn" {}
variable "lambda_version" {}

variable "domain_name" {
  default = "NOTSET"
}

variable "domain_zone_id" {
  default = "NOTSET"
}

variable "certificate_arn" {
  default = "NOTSET"
}

variable "stage_name" {
  default = "api"
}

variable "api_version" {
  default = "v1"
}

variable "authorizer_uri" {
  default = "NOT_SET"
}

variable "api_caller_ps_name" {
  default = "/env/apiCaller"
}

variable "lambda_authorizer_name" {
  default = "NOT_SET"
}

variable "cache_enabled" {
  default = "false"
}

variable "cache_encrypted" {
  default = "false"
}

variable "cache_ttl_in_seconds" {
  default = 120
}

variable "cache_cluster_size" {
  default = "0.5"
}

variable "api_gateway_endpoint_configuration_types" {
  default = ["REGIONAL"]
}

variable "api_gateway_security_policy" {
  default = "TLS_1_2"
}

locals {
  pub_gateway_name = "${var.function_name}-public"
  gateway_name     = "${var.authorizer_uri == "NOT_SET" ? var.function_name : local.pub_gateway_name}"
}

locals {
  authorizer_name        = "${var.function_name}-authorizer"
  formatted_arn          = "\"${var.invoke_arn}\""
  formatted_auth_uri     = "\"${var.authorizer_uri}\""
  formatted_gateway_name = "\"${local.gateway_name}\""
  formatted_title_swagger = "${replace(file(var.swagger_api_file), "/(\"title\"\\s*:\\s*)\"(\\S*)\"/", "$1${local.formatted_gateway_name}")}"
  formatted_uri_swagger = "${replace(local.formatted_title_swagger, "/(\"uri\"\\s*:\\s*)\"(arn:aws:apigateway:\\S*)\"/", "$1${local.formatted_arn}")}"
  formatted_authuri_swagger = "${replace(local.formatted_uri_swagger, "/(\"authorizerUri\"\\s*:\\s*)\"(arn:aws:apigateway:\\S*)\"/", "$1${local.formatted_auth_uri}")}"
  invoke_statement_id = "${uuid()-${var.lambda_version}}"
  auth_invoke_statement_id = "${uuid()}-${var.lambda_version}"
}
