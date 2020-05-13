resource "aws_ssm_parameter" "parameter" {
  name      = "${var.name}"
  type      = "${var.type}"
  value     = "${var.value}"
  overwrite = "${var.overwrite}"

  tags = {
    Name     = "${var.name}"
    Owner    = "${var.owner}"
    Resource = "${var.resource_type}"
  }
}
