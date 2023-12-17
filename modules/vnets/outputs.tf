output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "db_public_subnet_id" {
  value = azurerm_subnet.db_public.id
}

output "db_private_subnet_id" {
  value = azurerm_subnet.db_private.id
}

output "db_public_subnet_name" {
  value = azurerm_subnet.db_public.name
}

output "db_private_subnet_name" {
  value = azurerm_subnet.db_private.name
}

output "db_public_subnet_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.public.id
}

output "db_private_subnet_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.private.id
}

output "pl_subnet_id" {
  value = azurerm_subnet.pl_subnet.id
}

output "windows_server_nic" {
  value = azurerm_network_interface.vm_windows_server.id
}
