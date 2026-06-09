variable "subscription_id" {
  type    = string
  default = null
}

variable "tenant_id" {
  type    = string
  default = null
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "prod"], lower(var.environment))
    error_message = "environment must be either 'dev' or 'prod'."
  }
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "application_name" {
  type    = string
  default = "cloudats"
}

variable "app_service_sku" {
  type    = string
  default = "P1v3"
}

variable "app_service_linux_fx_version" {
  type    = string
  default = "NODE|18-lts"
}

variable "function_app_plan_sku" {
  type    = string
  default = "P1v3"
}

variable "function_app_runtime_version" {
  type    = string
  default = "NODE|18-lts"
}

variable "log_analytics_retention_days" {
  type    = number
  default = 30

  validation {
    condition     = var.log_analytics_retention_days >= 7
    error_message = "log_analytics_retention_days must be at least 7 days."
  }
}

variable "jwt_secret" {
  type      = string
  sensitive = true

  validation {
    condition     = length(trim(var.jwt_secret)) > 0
    error_message = "jwt_secret must be set and cannot be empty."
  }
}

variable "smtp_host" {
  type    = string
  default = ""
}

variable "smtp_port" {
  type    = number
  default = 587
}

variable "smtp_user" {
  type    = string
  default = ""
}

variable "smtp_pass" {
  type      = string
  sensitive = true
  default   = ""
}

variable "smtp_from" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {
    Project = "Cloud-ATS"
    Owner   = "CloudATS"
  }
}
