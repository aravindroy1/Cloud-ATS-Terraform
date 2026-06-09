variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "app_gateway_subnet_id" {
  type = string
}

variable "app_integration_subnet_id" {
  type = string
}

variable "data_subnet_id" {
  type = string
}

variable "app_gateway_subnet_cidr" {
  type = string
}

variable "app_integration_subnet_cidr" {
  type = string
}

variable "data_subnet_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}

