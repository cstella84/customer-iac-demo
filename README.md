# customer-iac-demo
## About
This is a simple demo used to perform the following tasks in Terraform:

1. Connect to Vault using Approle auth method
2. Generate short-lived dynamic AWS credentials with EC2 permissions
3. Log into AWS using dynamic credentials
4. Spin up EC2 instance

The purpose of this demo is to showcase a minimal IAC workflow in Terrafom that generates dynamic AWS credentials from a Vault instance and spins up an EC2 resource using those credentials.

## Prerequisites
The following steps must be performed on a Vault instance.

- Enable AWS secrets engine

`vault secrets enable aws`

- Configure AWS secrets engine  
>**NOTE:** Use an AWS IAM account with sufficient permissions to create new IAM users. [Example policy](https://developer.hashicorp.com/vault/docs/secrets/aws#example-iam-policy-for-vault)
```
vault write aws/config/root \
    access_key=<aws access key> \
    secret_key=<aws secret key> \
    region=us-west-2
```
- Create AWS secrets engine role with EC2 permissions
```
vault write aws/roles/ec2-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetUser",
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
```
- Enable Approle auth method

`vault auth enable approle`

- Create new Vault policy with permissions on AWS secrets engine path
```
vault policy write aws-ec2-policy -<<EOF
# Permissions to generate AWS credentials
path "aws/creds/ec2-role" {
    capabilities = ["read"]
}

# Permissions to create child token
path "auth/token/create" {
    capabilities = ["create", "read", "update"]
}
EOF
```
- Create Approle role with AWS EC2 permissions
```
vault write auth/approle/role/ec2 token_policies="aws-ec2-policy" \
    token_ttl=5m token_max_ttl=30m
```
- Read Approle role ID and secret ID to be used for authentication from Terraform (Input variables)
  - Role ID  
    `vault read auth/approle/role/ec2/role-id`

  - Secret ID  
    `vault write -f auth/approle/role/ec2/secret-id`

temp change
