data "aws_caller_identity" "current" {}

output "acc_id" {
    value = data.aws_caller_identity.current.account_id
}