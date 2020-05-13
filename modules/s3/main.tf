resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  region = "us-west-2"

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  tags {
    Resource = "s3_bucket"
    Owner    = "dtsong"
  }

}
