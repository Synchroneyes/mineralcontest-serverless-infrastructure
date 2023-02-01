module "authentification" {
  source = "./modules/authentification"

  region                          = local.aws_config.region
  cognito_user_pool_name          = local.aws_config.cognito_pool_name
  cognito_client_name             = local.aws_config.cognito_client_name
  cognito_client_callback_urls    = local.aws_config.cognito_client_callback_url
  cognito_client_read_attributes  = local.aws_config.cognito_client_read_attributes
  cognito_client_write_attributes = local.aws_config.cognito_client_write_attributes
}
