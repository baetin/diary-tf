resource "aws_instance" "diary_server" {
  ami                  = var.ami_id
  instance_type        = "t3.micro"
  subnet_id            = aws_subnet.public_a.id
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = { Name = "Diary-App-Server" }
}