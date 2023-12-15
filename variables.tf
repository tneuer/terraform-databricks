# TAGS

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], lower(var.environment))
    error_message = "Unsupported environement specified. Supported regions include: dev, prod"
  }
  default = "dev"
}

variable "location" {
  type = string
}

variable "project" {
  type = string
}

# RESOURCES

variable "vnet_cidr_range" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

data "azurerm_client_config" "current" {}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  tags = {
    environment = var.environment
    project     = var.project
    source      = "terraform"
    Owner       = lookup(data.external.me.result, "name")
  }
}
