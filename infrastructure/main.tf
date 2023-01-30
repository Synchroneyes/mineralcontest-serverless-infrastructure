module "authentification" {
  source = "./modules/authentification"

  region                          = local.aws_config.region
  cognito_user_pool_name          = local.aws_config.cognito_pool_name
  cognito_client_name             = local.aws_config.cognito_client_name
  cognito_client_callback_urls    = local.aws_config.cognito_client_callback_url
  cognito_client_read_attributes  = local.aws_config.cognito_client_read_attributes
  cognito_client_write_attributes = local.aws_config.cognito_client_write_attributes
}

module "lambda" {
  source           = "./modules/lambda"
  region           = local.aws_config.region
  function_runtime = "python3.8"
  function_handler = "lambda_handler"
  function_timeout = 900
  file_path        = "../code/lambda/hello-world.py"
  function_name    = "MyDemoLambdaTerraform"
}

output "userpoolid" {
  value = module.authentification.cognito_pool_id
}

output "cognito_client_secret" {
  value = nonsensitive(module.authentification.cognito_client_secret)
}
