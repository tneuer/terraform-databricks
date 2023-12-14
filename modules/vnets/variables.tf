variable "location" {
  type        = string
  description = "The Azure Region to deploy resources."

  validation {
    condition     = can(regex("^switzerland", var.location))
    error_message = "Unsupported Azure Region specified. Only Switzerland Regions are supported."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], lower(var.environment))
    error_message = "Unsupported environement specified. Supported regions include: dev, prod"
  }
}

variable "project" {
  type = string
}
