resource "azurerm_windows_virtual_machine" "vm_windows_server" {
  name                  = format("%s%s", "vm-windows-server-", var.project)
  computer_name = "dbAccessPoint"
  admin_username        = "azureuser"
  admin_password        = "MyNameIsEarl1!"
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [var.nic]
  size                  = "Standard_DS1_v2"
  tags                  = var.tags

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

output "public_ip_address" {
  value = "${azurerm_windows_virtual_machine.vm_windows_server.name}:${azurerm_windows_virtual_machine.vm_windows_server.public_ip_address}"
}
