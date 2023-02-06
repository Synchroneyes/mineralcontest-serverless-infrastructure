terraform {
  backend "s3" {
    bucket         = "mineralcontest-backend-terraform"
    region         = "eu-west-3"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform_state"
  }
}
