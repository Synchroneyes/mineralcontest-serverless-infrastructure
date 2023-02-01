resource "aws_api_gateway_rest_api" "name" {
  body = data.template_file.swagger.rendered
  name = "test-swagger-apigateway"

}

data "template_file" "swagger" {
  template = file("../swagger/api-gateway.yml")

  vars = {
    "region"           = local.aws_config.region
    "login_lambda_arn" = module.lambda_cognito_login.arn
  }

}
