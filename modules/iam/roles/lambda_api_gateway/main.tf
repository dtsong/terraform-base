resource "aws_iam_role" "lambda_api_gateway" {
  name = "lambda-api-gateway-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invoke_lambda" {
  name = "api-invoke-lambda-api-gateway"
  role = "${aws_iam_role.lambda_api_gateway.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "*"
    }
  ]
}
EOF
}
