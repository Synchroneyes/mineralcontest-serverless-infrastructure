variable "region" {
  type        = string
  description = "Region where to deploy the module"
}

variable "cognito_user_pool_name" {
  type        = string
  description = "Name of the cognito user pool"
}


variable "cognito_client_name" {
  type        = string
  description = "Name of the cognito client"
}

variable "cognito_client_callback_urls" {
  type        = set(any)
  description = "Set of client callback url"
}

variable "cognito_client_read_attributes" {
  type        = set(any)
  description = "Set of readable user's attribute."
}

variable "cognito_client_write_attributes" {
  type        = set(any)
  description = "Set of writeable user's attribute."
}
