output "instance_arn" {
  value = tolist(data.aws_ssoadmin_instances.main.arns)[0]
}

output "identity_store_id" {
  value = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}