resource "aws_iam_role" "lambda-role" {
  name = "${var.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-policy" {
  name = "${var.name}-policy"
  role = "${aws_iam_role.lambda-role.id}"

  policy = "${var.policy}"
}
