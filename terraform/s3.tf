locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))

  bash_cv_path   = "../bash_cv/build"
  bash_cv_prefix = ""

  static_cv_path   = "../html_cv"
  static_cv_prefix = ""
}

resource "aws_s3_bucket" "bash_cv" {
  bucket = "maximiliano-aguirre-cv"
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "bash_cv" {
  bucket = aws_s3_bucket.bash_cv.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.bash_cv.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "bash_cv" {
  for_each = fileset(local.bash_cv_path, "**")

  bucket       = aws_s3_bucket.bash_cv.id
  key          = "${local.bash_cv_prefix}${each.key}"
  source       = "${local.bash_cv_path}/${each.key}"
  etag         = filemd5("${local.bash_cv_path}/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}

resource "aws_s3_bucket" "static_cv" {
  bucket = "maximiliano-aguirre-static-cv"
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "static_cv" {
  bucket = aws_s3_bucket.static_cv.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.static_cv.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "static_cv" {
  for_each = fileset(local.static_cv_path, "**")

  bucket       = aws_s3_bucket.static_cv.id
  key          = "${local.static_cv_prefix}${each.key}"
  source       = "${local.static_cv_path}/${each.key}"
  etag         = filemd5("${local.static_cv_path}/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}
