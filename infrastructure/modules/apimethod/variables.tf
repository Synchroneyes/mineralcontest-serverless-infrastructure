variable "region" {
  type        = string
  description = "Region where to deploy the module"
}

variable "api_gateway_id" {
    type = string
    description = "ID of the api gateway to use"
}

variable "path" {
    type = string
    description = "path to use"
  
}

variable "cognito_authorizer_enable" {
    type = bool
    description = "Define wheter or not you shoud use a cognito authorizer"
    default = false
}

variable "cognito_authorizer_id" {
  type = string
  default = ""
  description = "ID of the cognito authorizer to use"
}

variable "parent_resource_id" {
  type = string
  description = "ID of the parent resource"
}

variable "method" {
  type = string
  description = "Method to use, GET, POST, ..."
}

variable "lambda_invoke_url" {
    type = string
    description = "Invoke URL of the lambda to use"
}

variable "lambda_name" {
  type = string
  description = "Name of the lambda to use"
}