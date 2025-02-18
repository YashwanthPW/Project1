provider "aws"{
    region ="us-east-1"
}

resource "aws_s3_bucket" "s3" {
  bucket = "100-buckets"
}



resource "aws_s3_bucket_public_access_block" "s3-public-block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3-ownership" {
  bucket = aws_s3_bucket.s3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "s3-acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = "public-read"
}

resource "aws_s3_object" "s3-object" {
  bucket = aws_s3_bucket.s3.id
  key    = "pdf.html"
  source = "pdf.html"
  content_type = "text/html"
  acl    = "public-read"
}



data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::100-buckets/pdf.html/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket =  aws_s3_bucket.s3.id # Replace with your bucket resource
  policy = data.aws_iam_policy_document.bucket_policy.json
}
