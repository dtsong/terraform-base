data "aws_ssm_parameter" "api_caller_role" {
  name = "${var.api_caller_ps_name}"
}

data "external" "git_hash" {
  program = ["${path.module}/utils/get_metadata.sh", "git_hash", "${var.filename}"]
}
