variable "alarm_actions" {
  type = "list"
  default = []
}

variable "region" {
   default = "us-east-1"
}

variable "lambda_filename" {
  default = "messages.jar"
}

variable "region_prefix" {
default = ""
}

variable "account_number" {
  default = "4214-71939647"
}

variable "url_to_check" {
default = ""
}

