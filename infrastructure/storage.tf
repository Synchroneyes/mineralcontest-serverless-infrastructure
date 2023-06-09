resource "aws_dynamodb_table" "users" {
  name = "mineralcontest_users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "user_mail"

  attribute {
    name = "user_mail"
    type = "S"
  }
}

resource "aws_dynamodb_table" "maps" {
  name = "mineralcontest_maps"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "map_id"

  attribute {
    name = "map_id"
    type = "S"
  }


}

resource "aws_dynamodb_table" "maps_download" {
  name = "mineralcontest_maps_download"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "dl_id"

  attribute {
    name = "dl_id"
    type = "S"
  }
}