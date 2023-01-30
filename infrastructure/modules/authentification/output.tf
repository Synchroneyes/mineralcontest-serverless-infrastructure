output "cognito_pool_id" {
  description = "Cognito user pool client id"
  value       = aws_cognito_user_pool.this.id
}

output "cognito_client_secret" {
  description = "Secret of the cognito client"
  value       = aws_cognito_user_pool_client.this.client_secret
}
