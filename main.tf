data "aws_ssoadmin_instances" "main" {}

resource "aws_identitystore_group" "admins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  display_name      = "Administrators"
  description       = "Full administrative access to AWS accounts"
}
