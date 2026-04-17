resource "aws_db_instance" "diary_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "diary_db"
  username               = "admin"
  password               = "pa$$w0rd" # 사용할 비밀번호로 바꾸세요 (8자 이상)
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false # EC2만 접속 가능하게 설정

  # 기존 파일(security_groups.tf 등)에 정의된 rds_sg의 id를 사용
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  # 아래에서 정의할 서브넷 그룹 이름과 일치시켜야 합니다
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

# DB가 위치할 서브넷 그룹 정의 (수정됨)
resource "aws_db_subnet_group" "default" {
  name       = "diary-db-subnet-group"
  
  # 태빈님의 vpc.tf에 정의된 실제 이름으로 수정했습니다.
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_c.id]

  tags = {
    Name = "Diary DB Subnet Group"
  }
}