locals {
  aws_config = yamldecode(file("./config/aws.yml"))
}
