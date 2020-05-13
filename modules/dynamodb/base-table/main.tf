resource "aws_dynamodb_table" "base-table" {
  name           = "INSERT_TABLE_NAME"
  read_capacity  = "${var.rcu}"
  write_capacity = "${var.wcu}"
  hash_key       = "INSERT_HASH_KEY"

  attribute {
    name = "INSERT_HASH_KEY"
    type = "S"
  }

  point_in_time_recovery {
    enabled = "${var.backups_enabled}"
  }

  lifecycle {
    prevent_destroy = false
  }

  tags {
    Resource = "dynamo_db_table"
    Owner    = "dtsong"
  }
}
