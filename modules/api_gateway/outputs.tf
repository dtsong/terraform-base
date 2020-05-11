output "api_invoke_url" {
  value = "${aws_api_gateway_deployment.gateway_deploy.invoke_url}"
}

output "formatted_swagger" {
  value = "${local.formatted_uri_swagger}"
}

output "id" {
  value = "${aws_api_gateway_rest_api.api_gateway.id}"
}
