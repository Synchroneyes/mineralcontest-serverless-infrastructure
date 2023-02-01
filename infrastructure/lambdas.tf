module "lambda_cognito_register" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/auth"
  file_name        = "register.py"
  function_name    = "mineralcontest-register"

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

  function_environment_variables = {
    "COGNITO_CLIENT_ID" = module.authentification.cognito_client_id,
  }
}
