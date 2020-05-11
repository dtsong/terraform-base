data "aws_ssm_parameter" "api_caller_role" {
  name = "${var.api_caller_ps_name}"
}

data "aws_iam_policy_document" "private_gw_policy" {
  statement {
    sid = "AllowPrivatePolicy"

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_ssm_parameter.api_caller_role.value}"]
    }

    actions = [
      "execute-api:Invoke",
    ]

    resources = [
      "*",
    ]
  }
}
