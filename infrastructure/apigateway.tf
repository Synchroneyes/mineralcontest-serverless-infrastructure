resource "aws_api_gateway_rest_api" "this" {
  name = "test-swagger-apigateway"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_authorizer" "this" {
  type = "COGNITO_USER_POOLS"
  rest_api_id = aws_api_gateway_rest_api.this.id
  name = "authorizerCognito"
  provider_arns = [module.authentification.cognito_pool_arn]
}

resource "aws_api_gateway_resource" "auth" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = "auth"
}

module "api_method_me" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = true
  cognito_authorizer_id = aws_api_gateway_authorizer.this.id
  lambda_invoke_url = module.lambda_cognito_authorizer_handler.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "me"
  method = "GET"
  lambda_name = module.lambda_cognito_authorizer_handler.name
}

module "api_method_login" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_cognito_login.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "login"
  method = "POST"
  lambda_name = module.lambda_cognito_login.name
}

module "api_method_register" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_cognito_register.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "register"
  method = "POST"
  lambda_name = module.lambda_cognito_register.name

}

resource "aws_api_gateway_resource" "maps" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = "maps"
}

module "api_method_maps_upload" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = true
  cognito_authorizer_id = aws_api_gateway_authorizer.this.id
  lambda_invoke_url = module.lambda_maps_upload.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps.id
  path = "upload"
  method = "POST"
  lambda_name = module.lambda_maps_upload.name
}

resource "aws_api_gateway_resource" "maps_name" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_resource.maps.id
  path_part = "{mapname}"
}

module "api_method_maps_info" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_maps_get_details.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps_name.id
  path = "details"
  method = "GET"
  lambda_name = module.lambda_maps_get_details.name
}

module "api_method_maps_download" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_maps_get_download.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps_name.id
  path = "download"
  method = "GET"
  lambda_name = module.lambda_maps_get_download.name
}

module "api_method_maps_image" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_maps_get_image.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps_name.id
  path = "image"
  method = "GET"
  lambda_name = module.lambda_maps_get_image.name
}