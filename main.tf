data "aws_ssoadmin_instances" "main" {}

data "aws_caller_identity" "current" {}

resource "aws_identitystore_group" "admins" {
  identity_store_id = local.identity_store_id
  display_name      = "Administrators"
  description       = "Full administrative access to AWS accounts"
}

resource "aws_identitystore_user" "baris" {
  identity_store_id = local.identity_store_id

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
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.admins.group_id
  member_id         = aws_identitystore_user.baris.user_id
}

resource "aws_ssoadmin_permission_set" "admin" {
  instance_arn     = local.instance_arn
  name             = "AdministratorAccess"
  description      = "Full admin access for the Administrators group"
  session_duration = "PT4H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
}

resource "aws_ssoadmin_account_assignment" "admins" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn

  principal_type = "GROUP"
  principal_id   = aws_identitystore_group.admins.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = data.aws_caller_identity.current.account_id
}
