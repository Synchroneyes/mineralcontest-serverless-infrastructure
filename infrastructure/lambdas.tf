module "lambda_cognito_register" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/auth"
  file_name        = "register.py"
  function_name    = "mineralcontest-register"
  api_gateway_arn  = aws_api_gateway_rest_api.this.execution_arn

  function_environment_variables = {
    "COGNITO_CLIENT_ID" = module.authentification.cognito_client_id,
  }
}

module "lambda_cognito_login" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/auth"
  file_name        = "login.py"
  function_name    = "mineralcontest-login"
  api_gateway_arn  = aws_api_gateway_rest_api.this.execution_arn

  function_environment_variables = {
    "COGNITO_CLIENT_ID" = module.authentification.cognito_client_id,
  }
}

module "lambda_cognito_authorizer_handler" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/auth"
  file_name        = "hello_protected.py"
  function_name    = "mineralcontest-hello-protected"
  api_gateway_arn  = aws_api_gateway_rest_api.this.execution_arn

  function_environment_variables = {
    "COGNITO_CLIENT_ID" = module.authentification.cognito_client_id,
  }
}


module "lambda_maps_upload" {
  source              = "./modules/lambda_s3"
  region              = local.aws_config.region
  function_runtime    = "python3.8"
  function_handler    = "lambda_handler"
  function_timeout    = 900
  file_path           = "../code/lambda/maps"
  file_name           = "upload_map.py"
  function_name       = "mineralcontest-maps-upload"
  api_gateway_arn     = aws_api_gateway_rest_api.this.execution_arn
  s3_maps_bucket_name = local.aws_config.s3_maps_bucket_name

  function_environment_variables = {
    "S3_MAPS_BUCKET_NAME" = local.aws_config.s3_maps_bucket_name
  }
}

module "lambda_maps_get_details" {
  source           = "./modules/lambda_custom_role"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/maps"
  file_name        = "get_details.py"
  function_name    = "mineralcontest-maps-get-details"
  api_gateway_arn  = aws_api_gateway_rest_api.this.execution_arn
  custom_role_arn  = aws_iam_role.lambda_assume_role_dynamodb.arn

}

module "lambda_maps_get_download" {
  source           = "./modules/lambda_custom_role"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/maps"
  file_name        = "download.py"
  function_name    = "mineralcontest-maps-get-download"
  api_gateway_arn  = aws_api_gateway_rest_api.this.execution_arn
  custom_role_arn  = aws_iam_role.lambda_assume_role_dynamodb.arn
}
