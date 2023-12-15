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

module "db_workspace" {
  source                                                  = "./modules/db_workspace"
  rg_name                                                 = var.rg_name
  location                                                = var.location
  project                                                 = var.project
  vnet_id                                                 = module.vnets.vnet_id
  db_public_subnet_name                                   = module.vnets.db_public_subnet_name
  db_private_subnet_name                                  = module.vnets.db_private_subnet_name
  db_public_subnet_network_security_group_association_id  = module.vnets.db_public_subnet_network_security_group_association_id
  db_private_subnet_network_security_group_association_id = module.vnets.db_private_subnet_network_security_group_association_id
  db_storage_account_name                                 = var.db_storage_account_name
  tags                                                    = local.tags
}

module "private_endpoints" {
  source                  = "./modules/private_endpoints"
  rg_name                 = var.rg_name
  location                = var.location
  project                 = var.project
  vnet_id                 = module.vnets.vnet_id
  pl_subnet_id            = module.vnets.pl_subnet_id
  databricks_workspace_id = module.db_workspace.databricks_workspace_id
  tags                    = local.tags
}

module "web_auth" {
  source                       = "./modules/web_auth"
  rg_name                      = var.rg_name
  location                     = var.location
  project                      = var.project
  pl_subnet_id                 = module.vnets.pl_subnet_id
  databricks_workspace_id      = module.db_workspace.databricks_workspace_id
  private_dns_zone_dnsuiapi_id = module.private_endpoints.private_dns_zone_dnsuiapi_id
  tags                         = local.tags
}

output "vnets" {
  value = module.vnets
}
