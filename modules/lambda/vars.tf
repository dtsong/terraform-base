variable "region" {}
variable "filename" {}
variable "role_arn" {}
variable "function_name" {}

variable "handler" {
  default = "app.app"
}

variable "runtime" {}

variable "timeout" {
  default = 900
}

variable "memory_size" {
  default = 3008
}

variable "log_level" {
  default = 10
}

variable "lambda_hash" {}

variable "env_variables" {
  type = "map"

  default = {
    LOG_LEVEL = 10
  }
}

variable "api_caller_ps_name" {
  default = "/env/apiCaller"
}

locals {
  git_hash          = "${data.external.git_hash.result["response"]}"
  all_env_variables = "${merge(var.env_variables, map("API_CALLER_ROLE", data.aws_ssm_parameter.api_caller_role.value))}"
}
