resource "aws_lambda_function" "this" {
  filename         = "${var.file_path}/${var.file_name}.zip"
  function_name    = var.function_name
  handler          = "${split(".", var.file_name)[0]}.${var.function_handler}"
  runtime          = var.function_runtime
  source_code_hash = filesha256("${var.file_path}/${var.file_name}")
  timeout          = var.function_timeout
  role             = aws_iam_role.this.arn

  environment {
    variables = var.function_environment_variables
  }

  depends_on = [
    null_resource.compression
  ]
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

resource "null_resource" "compression" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd ${var.file_path}; zip ${var.file_name}.zip ${var.file_name}"
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
    command = "rm ${var.file_path}/${var.file_name}.zip"
  }
}

