resource "aws_cloudwatch_event_rule" "on_s3_map_download" {
  name          = "on_s3_map_download"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail": {
    "eventName": [
      "GetObject"
    ],
    "requestParameters": {
      "key": [
        {
          "suffix": ".zip"
        }
      ]
    }
  }
}
EOF
}

data "archive_file" "s3_map_download" {
  type        = "zip"
  source_file = "../code/lambda/on_map_download.py"
  output_path = "../code/lambda/on_map_download.zip"
}

resource "aws_cloudwatch_event_target" "on_map_download" {
  rule      = aws_cloudwatch_event_rule.on_s3_map_download.name
  target_id = "sendToOnMapDownloadLambda"
  arn       = aws_lambda_function.on_map_download.arn
}

resource "aws_lambda_function" "on_map_download" {
  function_name    = "on_map_download"
  filename         = data.archive_file.s3_map_download.output_path
  handler          = "on_map_download.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filesha256(data.archive_file.s3_map_download.output_path)
  timeout          = "10"
  role             = aws_iam_role.s3_map_download.name
}

resource "aws_iam_role" "s3_map_download" {
  name = "s3_map_download"

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

resource "aws_iam_policy" "s3_map_download" {
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "dynamodb:PutItem",
			"Resource": "${aws_dynamodb_table.maps_download.arn}"
		}
	]
}

  EOF
}

resource "aws_iam_role_policy_attachment" "attach_to_s3_download" {
  role       = aws_iam_role.s3_map_download.name
  policy_arn = aws_iam_policy.s3_map_download.arn
}