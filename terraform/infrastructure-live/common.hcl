locals {
  accounts = jsondecode(file("accounts.json"))

  default_region = "us-east-1"

  name_prefix = "hometask"

}