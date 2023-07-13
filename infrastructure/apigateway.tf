resource "aws_api_gateway_rest_api" "this" {
  name = "mineralcontest-api"

  binary_media_types = ["image/jpeg"]
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_authorizer" "this" {
  type = "COGNITO_USER_POOLS"
  rest_api_id = aws_api_gateway_rest_api.this.id
  name = "authorizerCognito"
  provider_arns = [module.authentification.cognito_pool_arn]
}

resource "aws_api_gateway_resource" "auth" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = "auth"
}

module "api_method_me" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = true
  cognito_authorizer_id = aws_api_gateway_authorizer.this.id
  lambda_invoke_url = module.lambda_cognito_authorizer_handler.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "me"
  method = "GET"
  lambda_name = module.lambda_cognito_authorizer_handler.name
}

module "api_method_login" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_cognito_login.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "login"
  method = "POST"
  lambda_name = module.lambda_cognito_login.name
}

module "api_method_register" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_cognito_register.invoke_arn
  parent_resource_id = aws_api_gateway_resource.auth.id
  path = "register"
  method = "POST"
  lambda_name = module.lambda_cognito_register.name

}

resource "aws_api_gateway_resource" "maps" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_rest_api.this.root_resource_id
  path_part = "maps"
}

module "api_method_maps_upload" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = true
  cognito_authorizer_id = aws_api_gateway_authorizer.this.id
  lambda_invoke_url = module.lambda_maps_upload.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps.id
  path = "upload"
  method = "POST"
  lambda_name = module.lambda_maps_upload.name
}

resource "aws_api_gateway_resource" "maps_name" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_resource.maps.id
  path_part = "{mapname}"
}

module "api_method_maps_info" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_maps_get_details.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps_name.id
  path = "details"
  method = "GET"
  lambda_name = module.lambda_maps_get_details.name
}

module "api_method_maps_download" {
  source = "./modules/apimethod"
  region = local.aws_config.region
  api_gateway_id = aws_api_gateway_rest_api.this.id
  cognito_authorizer_enable = false
  lambda_invoke_url = module.lambda_maps_get_download.invoke_arn
  parent_resource_id = aws_api_gateway_resource.maps_name.id
  path = "download"
  method = "GET"
  lambda_name = module.lambda_maps_get_download.name
}

resource "aws_api_gateway_resource" "maps_thumbnail" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_resource.maps_name.id
  path_part = "thumbnail"
}

resource "aws_api_gateway_method" "maps_thumbnail_get" {
  resource_id = aws_api_gateway_resource.maps_thumbnail.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.mapname" = true
  }
}

resource "aws_api_gateway_integration" "maps_thumbnail_get_integration_request" {
  resource_id = aws_api_gateway_resource.maps_thumbnail.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  type = "AWS"
  integration_http_method = "GET"
  uri = "arn:aws:apigateway:${local.aws_config.region}:s3:path/${local.aws_config.s3_maps_bucket_name}/{mapname}/thumbnail.jpg"
  http_method = aws_api_gateway_method.maps_thumbnail_get.http_method
  credentials = "arn:aws:iam::982003693898:role/APIGatewayS3"
  
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.mapname" = "method.request.path.mapname"
  }
}


resource "aws_api_gateway_method_response" "maps_thumbnail_get_method_response" {
  resource_id = aws_api_gateway_resource.maps_thumbnail.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = aws_api_gateway_method.maps_thumbnail_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "image/jpeg" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "maps_thumbnail_get_integration_response" {
  depends_on = [aws_api_gateway_method_response.maps_thumbnail_get_method_response]

  resource_id = aws_api_gateway_resource.maps_thumbnail.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = aws_api_gateway_method.maps_thumbnail_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = "'image/jpeg'"
  }

  content_handling = "CONVERT_TO_BINARY"
}


# ---

resource "aws_api_gateway_resource" "maps_image" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id = aws_api_gateway_resource.maps_name.id
  path_part = "image"
}

resource "aws_api_gateway_method" "maps_image_get" {
  resource_id = aws_api_gateway_resource.maps_image.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.mapname" = true
  }
}

resource "aws_api_gateway_integration" "maps_image_get_integration_request" {
  resource_id = aws_api_gateway_resource.maps_image.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  type = "AWS"
  integration_http_method = "GET"
  uri = "arn:aws:apigateway:${local.aws_config.region}:s3:path/${local.aws_config.s3_maps_bucket_name}/{mapname}/{mapname}.jpg"
  http_method = aws_api_gateway_method.maps_image_get.http_method
  credentials = "arn:aws:iam::982003693898:role/APIGatewayS3"
  
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.path.mapname" = "method.request.path.mapname"
  }
}


resource "aws_api_gateway_method_response" "maps_image_get_method_response" {
  resource_id = aws_api_gateway_resource.maps_image.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = aws_api_gateway_method.maps_image_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = true
  }

}

resource "aws_api_gateway_integration_response" "maps_image_get_integration_response" {
  depends_on = [ aws_api_gateway_method_response.maps_image_get_method_response ]
  resource_id = aws_api_gateway_resource.maps_image.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  http_method = aws_api_gateway_method.maps_image_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Content-Type" = "'image/jpeg'"
  }

  content_handling = "CONVERT_TO_BINARY"
}

