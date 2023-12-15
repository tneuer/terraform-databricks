resource "azurerm_private_endpoint" "auth" {
  name                = format("%s%s", var.project, "aadauthpvtendpoint")
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.pl_subnet_id

  private_service_connection {
    name                           = format("%s%s", var.project, "-ple-auth")
    private_connection_resource_id = var.databricks_workspace_id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-auth"
    private_dns_zone_ids = [var.private_dns_zone_dnsuiapi_id]
  }
  tags = var.tags
}