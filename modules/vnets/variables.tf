variable "location" {
  type        = string
  description = "The Azure Region to deploy resources."

  validation {
    condition     = can(regex("^switzerland", var.location))
    error_message = "Unsupported Azure Region specified. Only Switzerland Regions are supported."
  }
}

variable "project" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "vnet_cidr_range" {
  type = string
}

variable "tags" {
  type = map(any)
}
