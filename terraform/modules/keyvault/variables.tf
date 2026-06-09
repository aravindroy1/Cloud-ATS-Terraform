variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "current_principal_id" {
  type = string
}

variable "app_gateway_identity_principal_id" {
  type = string
}

variable "certificate_name" {
  type = string
}

variable "certificate_subject" {
  type = string
}

variable "secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "tags" {
  type = map(string)
}
