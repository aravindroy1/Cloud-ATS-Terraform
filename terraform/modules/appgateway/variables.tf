variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "application_name" {
  type = string
}

variable "app_gateway_subnet_id" {
  type = string
}

variable "app_service_private_ip" {
  type = string
}

variable "app_service_default_hostname" {
  type = string
}

variable "ssl_certificate_secret_id" {
  type = string
}

variable "user_assigned_identity_id" {
  type = string
}

variable "public_dns_label" {
  type = string
}

variable "tags" {
  type = map(string)
}
