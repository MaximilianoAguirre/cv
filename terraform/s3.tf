locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}

resource "aws_s3_bucket" "container" {
  bucket = "maximiliano-aguirre-cv"
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "container_policy" {
  bucket = aws_s3_bucket.container.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.container.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("../bash_cv/build", "**")

  bucket       = aws_s3_bucket.container.id
  key          = each.key
  source       = "../bash_cv/build/${each.key}"
  etag         = filemd5("../bash_cv/build/${each.key}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}
