output "bucket_name" {
  value = "${var.target_bucket_name}"
}

output "s3_key" {
  value = "${aws_s3_bucket_object.file.id}"
}
