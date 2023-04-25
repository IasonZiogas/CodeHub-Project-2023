terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}


resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-PublicIp2"
  resource_group_name = "${var.prefix}-codehub-reg"
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}



resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-codehub-nic2"
  location            = var.location
  resource_group_name = "${var.prefix}-codehub-reg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/139a319c-df00-476d-9252-94623e31323f/resourceGroups/Regen-Project-codehub-reg/providers/Microsoft.Network/virtualNetworks/Regen-Project-codehub-network/subnets/Regen-Project-codehub-subnetwork"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}




resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm-node"
  location              = var.location
  resource_group_name   = "${var.prefix}-codehub-reg"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


variable "location" {}
variable "prefix" {}
variable "admin_username"{}
variable "admin_password"{}

# commen 1 to check webooks
# comment 2
##comment 3