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

variable "log_analytics_retention_days" {
  type = number
}

variable "tags" {
  type = map(string)
}

