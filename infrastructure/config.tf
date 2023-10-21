terraform {
  backend "s3" {
    bucket = "mineralcontest-backend-terraform-state"
    region = "eu-west-3"
    key    = "terraform.tfstate"
  }
}
