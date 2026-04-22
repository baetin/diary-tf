# 1. S3 버킷 생성
resource "aws_s3_bucket" "storage" {
  bucket = var.s3_bucket_name
}

# 2. 퍼블릭 액세스 차단 설정 (ACL은 막고, Policy는 열어둠)
resource "aws_s3_bucket_public_access_block" "storage_access" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true   # ACL을 통한 업로드는 차단 (에러 방지)
  block_public_policy     = false  # 버킷 정책으로 읽는 것은 허용
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# 3. 버킷 정책 (누구나 사진을 읽을 수 있게 설정)
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.storage.id

  depends_on = [aws_s3_bucket_public_access_block.storage_access]
  
  # 위에서 ACL을 막았으므로, 이 정책이 있어야 브라우저에서 사진이 보입니다.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.storage.arn}/*"
      },
    ]
  })
}