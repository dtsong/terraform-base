resource "aws_s3_bucket_object" "file" {
  bucket  = "${var.target_bucket_name}"
  key     = "${var.path_to_upload}"
  content = "${var.content}"
}
