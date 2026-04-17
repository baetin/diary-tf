output "alb_dns_name" { value = aws_lb.diary_alb.dns_name }
output "ec2_public_ip" { value = aws_instance.diary_server.public_ip }