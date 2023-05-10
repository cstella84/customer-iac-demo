output "instance_ami" {
  value = aws_instance.aws-ec2.ami
}

output "instance_arn" {
  value = aws_instance.aws-ec2.arn
}
