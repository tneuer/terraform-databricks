locals {
  tags = {
    environment = var.environment
    project     = var.project
    source      = "terraform"
  }
}

resource "azurerm_resource_group" "base_rg" {
  name     = "terraform-test-resource"
  location = var.location
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "tfstatekv" {
  name                = "tfstatekv"
  resource_group_name = azurerm_resource_group.base_rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

data "azurerm_key_vault_secret" "linux_pwd" {
  name         = "linux-pwd"
  key_vault_id = azurerm_key_vault.tfstatekv.id
}

resource "azurerm_virtual_network" "base_vn" {
  name                = "terraform-test-network"
  resource_group_name = azurerm_resource_group.base_rg.name
  location            = azurerm_resource_group.base_rg.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "base_subnet1" {
  name                 = "subnet_1"
  resource_group_name  = azurerm_resource_group.base_rg.name
  virtual_network_name = azurerm_virtual_network.base_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "base_subnet2" {
  name                 = "subnet_2"
  resource_group_name  = azurerm_resource_group.base_rg.name
  virtual_network_name = azurerm_virtual_network.base_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg_test" {
  name                = "test_nsg"
  location            = azurerm_resource_group.base_rg.location
  resource_group_name = azurerm_resource_group.base_rg.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "nsr_test" {
  name                        = "allow_my_IP"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "77.59.128.10/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.base_rg.name
  network_security_group_name = azurerm_network_security_group.nsg_test.name
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_1" {
  subnet_id                 = azurerm_subnet.base_subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg_test.id
}

resource "azurerm_public_ip" "public_ip_test" {
  name                = "public_ip_test"
  resource_group_name = azurerm_resource_group.base_rg.name
  location            = azurerm_resource_group.base_rg.location
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_network_interface" "nic_test" {
  name                = "nic_test"
  location            = azurerm_resource_group.base_rg.location
  resource_group_name = azurerm_resource_group.base_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.base_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_test.id
  }
  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "linux_vm_test" {
  name                            = "linuxvmtest"
  resource_group_name             = azurerm_resource_group.base_rg.name
  location                        = azurerm_resource_group.base_rg.location
  size                            = "Standard_B1s"
  admin_username                  = "adminuser"
  admin_password                  = data.azurerm_key_vault_secret.linux_pwd.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_test.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.linux_vm_test.name}:${azurerm_linux_virtual_machine.linux_vm_test.public_ip_address}"
}
