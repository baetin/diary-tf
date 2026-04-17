# ALB용: 외부에서 80, 443 허용
resource "aws_security_group" "alb_sg" {
  name   = "diary-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2용: ALB로부터 오는 3000번 포트만 허용
resource "aws_security_group" "web_sg" {
  name   = "diary-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS 전용 보안 그룹 생성
resource "aws_security_group" "rds_sg" {
  name        = "diary-rds-sg"
  description = "Allow MySQL traffic from EC2"
  vpc_id      = aws_vpc.main.id # 보내주신 vpc 이름 'main'에 맞췄습니다.

  # 인바운드 규칙: web_sg를 가진 EC2만 3306 포트(MySQL) 접속 허용
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id] # 보내주신 'web_sg'에 맞췄습니다.
  }

  # 아웃바운드 규칙: 밖으로 나가는 트래픽은 모두 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Diary RDS SG"
  }
}