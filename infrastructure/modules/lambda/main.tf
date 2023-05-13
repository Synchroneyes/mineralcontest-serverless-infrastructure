#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda.output_path
  function_name    = var.function_name
  handler          = "${split(".", var.file_name)[0]}.${var.function_handler}"
  runtime          = var.function_runtime
  source_code_hash = filesha256(data.archive_file.lambda.output_path)
  timeout          = var.function_timeout
  role             = aws_iam_role.this.arn


  #checkov:skip=CKV_AWS_50:No use of X-RAY
  #checkov:skip=CKV_AWS_272:No use of code signing
  #checkov:skip=CKV_AWS_116:No need for a DLQ

  # TODO
  #checkov:skip=CKV_AWS_173:No use of encryption for now
  #checkov:skip=CKV_AWS_117:lambda_vpc No Need for now, might need later

  environment {
    variables = var.function_environment_variables
  }

}

resource "aws_lambda_permission" "api-gateway-invoke-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_arn}/*/*"
}

resource "aws_iam_role" "this" {
  name = "iam_for_lambda_${var.file_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda" {
  type = "zip"
  source_file = "${var.file_path}/${var.file_name}"
  output_path = "${var.file_path}/${var.file_name}.zip"
}

