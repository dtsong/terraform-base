variable "region" {}
variable "name" {}

variable "event_target_arn" {}

variable "schedule" {
  default = "rate(1 minute)"
}
