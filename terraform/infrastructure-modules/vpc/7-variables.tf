variable "env" {
    type = string
    description = "Environment name."
}

variable "vpc_cidr_block" {
    description = "CIDR range for VPC."
    type = string
    default = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets."
  type        = list(string)
}

variable "private_subnets" {
    description = "CIDR ranges for private subnets."
        type = list(string)
    }

variable "public_subnets" {
    description = "CIDR ranges for public subnets."
    type = list(string)
}

variable "private_subnet_tags" {
  description = "Private subnet tags."
  type = map(any)
}

variable "public_subnet_tags" {
  description = "Private subnet tags."
  type = map(any)
}