resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.resource_group_location  
}

resource "azurerm_virtual_network" "vn" {
  name = var.virtual_network_name
  location = azurerm_resource_group.rg.location
  address_space = var.address_space
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vn_snet1" {
    resource_group_name = azurerm_resource_group.rg.name
    name=var.vnet_subnet_name
    address_prefixes = ["10.0.0.0/24"] 
    virtual_network_name = azurerm_virtual_network.vn.name
}

resource "azurerm_public_ip" "pubip" {
  name = var.public_ip_name
  allocation_method = "Dynamic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


}

resource "azurerm_network_interface" "ni" {
    name = var.network_interface_1
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_accelerated_networking = true
    ip_configuration {
      name = "internal"
      private_ip_address_allocation = "Dynamic"
      subnet_id = azurerm_subnet.vn_snet1.id
      public_ip_address_id = azurerm_public_ip.pubip.id 
    }  
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = var.linuxvm_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
  }
  admin_username = "demouser"
  admin_password = "avinash@2002"
  computer_name = "avinashvm"
  network_interface_ids = [
      azurerm_network_interface.ni.id,
    ]
  size = "Standard_DS1_v2"
  tags = {
      "environment" = "dev"
  } 
  os_disk {
    name = "demo_disk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }
  disable_password_authentication = false


}