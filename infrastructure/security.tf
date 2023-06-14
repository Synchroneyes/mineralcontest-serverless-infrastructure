resource "aws_iam_policy" "lambda_policy_access_dynamodb_and_s3" {
  name        = "lambda_policy_access_dynamodb_and_s3"
  description = "Allows Lambda to perform DynamoDB operations"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:UpdateItem",
        "dynamodb:Scan",
        "dynamodb:Query"
      ],
      "Resource": [
        "${aws_dynamodb_table.maps.arn}",
        "${aws_dynamodb_table.maps_download.arn}",
        "${aws_dynamodb_table.maps_download.arn}/*"
      ]
    },
    {
      "Sid": "S3Access",
      "Effect": "Allow",
      "Action": [
        "s3:GetItem"
      ],
      "Resource": [
        "arn:aws:s3:::mineralcontestmaps"
      ]
    },
    {
      "Sid": "Cloudwatch",
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_assume_role_dynamodb" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy_access_dynamodb_and_s3.arn
  role       = aws_iam_role.lambda_assume_role_dynamodb.name
}
