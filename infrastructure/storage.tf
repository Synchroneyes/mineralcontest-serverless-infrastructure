resource "aws_dynamodb_table" "users" {
  name         = "mineralcontest_users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_mail"

  attribute {
    name = "user_mail"
    type = "S"
  }
}

resource "aws_dynamodb_table" "maps" {
  name         = "mineralcontest_maps"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "map_name"

  attribute {
    name = "map_name"
    type = "S"
  }


}

resource "aws_dynamodb_table" "maps_download" {
  name         = "mineralcontest_maps_download"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id_dl"

  attribute {
    name = "map_name"
    type = "S"
  }

  global_secondary_index {
    name            = "map_name-index"
    hash_key        = "map_name"
    projection_type = "ALL"
  }

  attribute {
    name = "id_dl"
    type = "S"
  }
}
