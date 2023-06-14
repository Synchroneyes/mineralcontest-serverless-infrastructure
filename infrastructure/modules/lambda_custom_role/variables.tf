variable "region" {
  type        = string
  description = "Region where to deploy the module"
}

variable "file_path" {
  type        = string
  description = "Path of the file to create the lambda from"
}

variable "file_name" {
  type        = string
  description = "name of the file to create the lambda from"
}

variable "function_handler" {
  type        = string
  description = "Name of the lambda function's entry function"
}

variable "function_runtime" {
  type        = string
  description = "Runtime to use for the lambda function"
}

variable "function_name" {
  type        = string
  description = "Name of the function"
}

variable "function_timeout" {
  type        = number
  description = "Timeout to use for the function"
}

variable "function_environment_variables" {
  default = {}
}

variable "api_gateway_arn" {
  type        = string
  description = "ARN of the api gateway to use"
}

variable "custom_role_arn" {
  type = string
  default = ""
}
