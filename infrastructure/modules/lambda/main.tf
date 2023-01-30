resource "aws_lambda_function" "this" {
  filename         = "${var.file_path}.zip"
  function_name    = var.function_name
  handler          = var.function_handler
  runtime          = var.function_runtime
  source_code_hash = filesha256(var.file_path)
  timeout          = var.function_timeout
  role             = aws_iam_role.iam_for_lambda.arn

  depends_on = [
    null_resource.compression
  ]
}

resource "null_resource" "compression" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "zip -r ${var.file_path}.zip ${var.file_path}"
  }
}
resource "null_resource" "clear_zip" {

  depends_on = [
    aws_lambda_function.this
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "rm ${var.file_path}.zip"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

