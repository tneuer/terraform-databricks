resource "azurerm_databricks_workspace" "db_workspace1" {
  name                                  = format("%s%s", var.project, "-workspace")
  resource_group_name                   = var.rg_name
  location                              = var.location
  sku                                   = "premium"
  tags                                  = var.tags
  public_network_access_enabled         = true # false
  # network_security_group_rules_required = "NoAzureDatabricksRules"
  customer_managed_key_enabled          = true
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.db_public_subnet_name
    private_subnet_name                                  = var.db_private_subnet_name
    public_subnet_network_security_group_association_id  = var.db_public_subnet_network_security_group_association_id
    private_subnet_network_security_group_association_id = var.db_private_subnet_network_security_group_association_id
    storage_account_name                                 = var.db_storage_account_name
  }

  depends_on = [
    var.db_public_subnet_network_security_group_association_id,
    var.db_private_subnet_network_security_group_association_id
  ]
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.db_workspace1.id
}
