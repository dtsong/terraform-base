output "name" {
  value = "${aws_dynamodb_table.base-table.id}"
}
