data "aws_ssoadmin_instances" "main" {}

resource "aws_identitystore_group" "admins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  display_name      = "Administrators"
  description       = "Full administrative access to AWS accounts"
}

resource "aws_identitystore_user" "baris" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]

  user_name    = "baris.ekinci"
  display_name = "Baris Ekinci"

  name {
    given_name  = "Baris"
    family_name = "Ekinci"
  }

  emails {
    value   = "barekinci91+sso@gmail.com"
    primary = true
  }
}

resource "aws_identitystore_group_membership" "baris_admins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.baris.user_id
}

resource "aws_ssoadmin_permission_set" "admin" {
  instance_arn     = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  name             = "AdministratorAccess"
  description      = "Full admin access for the Administrators group"
  session_duration = "PT4H"
}
