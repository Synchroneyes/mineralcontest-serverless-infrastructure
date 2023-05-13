data "aws_caller_identity" "current" {}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.api_gateway_id
  parent_id = var.parent_resource_id
  path_part = var.path
}

resource "aws_api_gateway_method" "with_authorizer" {
  count = var.cognito_authorizer_enable ? 1 : 0
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = var.method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = var.cognito_authorizer_id
}

resource "aws_api_gateway_method" "without_authorizer" {
  count = var.cognito_authorizer_enable ? 0 : 1
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = var.method
  authorization = "NONE"
  authorizer_id = var.cognito_authorizer_id
}

resource "aws_api_gateway_integration" "this" {
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  type = "AWS"
  http_method = var.method
  integration_http_method = "POST"
  uri = var.lambda_invoke_url
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*/${var.method}${aws_api_gateway_resource.this.path}"
}

resource "aws_api_gateway_method_response" "without_authorizer" {
  count = var.cognito_authorizer_enable ? 0 : 1
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = aws_api_gateway_method.without_authorizer[0].http_method
  status_code = 200
}

resource "aws_api_gateway_method_response" "with_authorizer" {
  count = var.cognito_authorizer_enable ? 1 : 0
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = aws_api_gateway_method.with_authorizer[0].http_method
  status_code = 200
}


resource "aws_api_gateway_integration_response" "with_authorizer" {
  count = var.cognito_authorizer_enable ? 1 : 0
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = aws_api_gateway_method_response.with_authorizer[0].http_method
  status_code = aws_api_gateway_method_response.with_authorizer[0].status_code
  depends_on = [ aws_api_gateway_integration.this ]
}
resource "aws_api_gateway_integration_response" "without_authorizer" {
  count = var.cognito_authorizer_enable ? 0 : 1
  resource_id = aws_api_gateway_resource.this.id
  rest_api_id = var.api_gateway_id
  http_method = aws_api_gateway_method_response.without_authorizer[0].http_method
  status_code = aws_api_gateway_method_response.without_authorizer[0].status_code

  depends_on = [ aws_api_gateway_integration.this ]
}