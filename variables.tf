variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.nano"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Updated latest"
}

variable "vault_backend" {
  description = "Path to AWS secrets engine"
  default     = "aws"
}

variable "vault_role" {
  description = "Name of AWS secrets engine EC2 role"
  default     = "ec2-role"
}

variable "login_approle_role_id" {
  description = "Role ID for Approle auth method"
}

variable "login_approle_secret_id" {
  description = "Secret ID for Approle auth method"
}
