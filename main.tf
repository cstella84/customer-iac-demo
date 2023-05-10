# Authenticate with HCP Vault
provider "vault" {
  namespace = var.vault_namespace
  address   = var.vault_address
  auth_login {
    path      = "auth/approle/login"
    namespace = var.vault_namespace
    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}

# Generate dynamic AWS secrets from HCP Vault 
data "vault_aws_access_credentials" "creds" {
  backend = var.vault_backend
  role    = var.vault_role
}

# Authenticate with AWS using dynamic creds
provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

# Pull latest ubuntu image from AWS
data "aws_ami" "aws-ec2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230503.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

# Create AWS EC2 Instance
resource "aws_instance" "aws-ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

resource "aws_instance" "aws-ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
