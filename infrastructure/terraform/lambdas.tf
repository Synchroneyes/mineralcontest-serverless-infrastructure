module "lambda_cognito_register" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../../code/lambda/auth"
  file_name        = "register.py"
  function_name    = "mineralcontest-register"
  api_gateway_arn  = aws_api_gateway_rest_api.name.execution_arn

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
  file_path        = "../../code/lambda/auth"
  file_name        = "login.py"
  function_name    = "mineralcontest-login"
  api_gateway_arn  = aws_api_gateway_rest_api.name.execution_arn


  function_environment_variables = {
    "COGNITO_CLIENT_ID" = module.authentification.cognito_client_id,
  }
}
