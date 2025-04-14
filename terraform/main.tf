# Terraform Module for Multiple EC2 Instances
#############################################################

# variables.tf
variable "ec2_config" {
  description = "Map of EC2 configuations"
  type = map(object({
    instance_type = string
    volume_type   = string
    volume_size   = number
    key_name      = string
  }))
}

# main.tf
resource "aws_instance" "multi_ec2" {
  for_each = var.ec2_config

  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  root_block_device {
    volume_type = each.value.volume_type
    volume_size = each.value.volume_size
  }

  tags = {
    Name = "${each.key}"
  }
}

# example usage - ec2.tfvars
/*
ec2_config = {
  ec2_1 = {
    instance_type = "t2.micro"
    volume_type   = "gp2"
    volume_size   = 8
    key_name      = "key1"
  }
  ec2_2 = {
    instance_type = "m5.large"
    volume_type   = "io1"
    volume_size   = 20
    key_name      = "key2"
  }
  ec2_3 = { ... }
  ec2_4 = { ... }
  ec2_5 = { ... }
}
*/

# ---------------------------------------------
# IAM Setup for Accounts
# ---------------------------------------------

# Step 1 - Groups and Users in 000000000000
resource "aws_iam_group" "cli_group" {
  name = "group1"
}

resource "aws_iam_group" "full_access_group" {
  name = "group2"
}

resource "aws_iam_user" "cli_users" {
  for_each = toset(["engine", "ci"])
  name     = each.key
}

resource "aws_iam_user_group_membership" "cli_group_membership" {
  for_each = toset(["engine", "ci"])
  user     = each.key
  groups   = [aws_iam_group.cli_group.name]
}

resource "aws_iam_user" "full_users" {
  for_each = toset(["JohnDoe", "AboubacarMaina"])
  name     = each.key
}

resource "aws_iam_user_group_membership" "full_group_membership" {
  for_each = toset(["JohnDoe", "AboubacarMaina"])
  user     = each.key
  groups   = [aws_iam_group.full_access_group.name]
}

resource "aws_iam_group_policy_attachment" "cli_policy" {
  group      = aws_iam_group.cli_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCLIOnlyAccess" # Example custom policy
}

resource "aws_iam_group_policy_attachment" "full_policy" {
  group      = aws_iam_group.full_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Step 2 - Create Roles in 000000000000
resource "aws_iam_role" "roleA" {
  name = "roleA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleA_policy" {
  name = "roleA-policy"
  role = aws_iam_role.roleA.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",
      Resource = "*",
      Condition = {
        StringNotEquals = {
          "aws:RequestedService" = "iam.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role" "roleB" {
  name = "roleB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleB_policy" {
  name = "assume-roleC"
  role = aws_iam_role.roleB.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Resource = "arn:aws:iam::1111111111:role/roleC"
    }]
  })
}

# Step 3 - RoleC in 1111111111 
resource "aws_iam_role" "roleC" {
  name = "roleC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::000000000000:role/roleB"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleC_policy" {
  name = "s3-full-access"
  role = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "s3:*",
      Resource = [
        "arn:aws:s3:::aws-test-bucket",
        "arn:aws:s3:::aws-test-bucket/*"
      ]
    }]
  })
}

