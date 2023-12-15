resource "azurerm_private_endpoint" "uiapi" {
  name                = "uiapipvtendpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pl_subnet_id

  private_service_connection {
    name                           = format("%s%s", var.project, "-ple-uiapi")
    private_connection_resource_id = var.databricks_workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-uiapi"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsuiapi.id]
  }
}

resource "azurerm_private_dns_zone" "dnsuiapi" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "uiapidnszonevnetlink" {
  name                  = "uiapispokevnetconnection"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.dnsuiapi.name
  virtual_network_id    = var.vnet_id // connect to spoke vnet
}

output "private_dns_zone_dnsuiapi_id" {
  value = azurerm_private_dns_zone.dnsuiapi.id
}
