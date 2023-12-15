terraform {
  required_version = ">= 1.6.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_key_vault" "tfstatekv" {
  name                = var.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

module "vnets" {
  source          = "./modules/vnets"
  rg_name         = var.rg_name
  location        = var.location
  project         = var.project
  vnet_cidr_range = var.vnet_cidr_range
  tags            = local.tags
}
