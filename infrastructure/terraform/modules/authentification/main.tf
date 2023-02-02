resource "aws_cognito_user_pool" "this" {
  name = var.cognito_user_pool_name

  # Require email
  alias_attributes  = ["email"]
  mfa_configuration = "OFF"

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 1
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message_by_link = "Merci de confirmer votre inscription en cliquant sur le lien suivant: {##Click Here##}"
    email_message         = "Merci de confirmer votre compte en cliquant sur le lien suivant: {####}."
    email_subject         = "Mineral Contest - Confirmation de compte"

  }

}

resource "aws_cognito_user_pool_client" "this" {
  name            = var.cognito_client_name
  user_pool_id    = aws_cognito_user_pool.this.id
  generate_secret = false

  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

  callback_urls    = var.cognito_client_callback_urls
  write_attributes = var.cognito_client_write_attributes
  read_attributes  = var.cognito_client_read_attributes
}

