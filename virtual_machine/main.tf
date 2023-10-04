provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "development"  # Customize tags as needed
  }
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  tags = {
    environment = "development"
  }
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_storage_account" "my_storage" {
  name                     = "mystorageaccountpract"
  resource_group_name      = azurerm_resource_group.my_rg.name
  location                 = azurerm_resource_group.my_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "development"
  }
}

resource "azurerm_network_interface" "my_nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "my-nic-config"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "my_vm" {
  name                  = "my-vm"
  resource_group_name   = azurerm_resource_group.my_rg.name
  location              = azurerm_resource_group.my_rg.location
  size                  = "Standard_DS2_v2"
  admin_username        = var.vm_username
  admin_password        = var.vm_password
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  source_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2019-Datacenter"
  version   = "latest"
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = "development"
  }

}

# Azure SQL Server and Database configurations go here
resource "azurerm_sql_server" "my_sql_server" {
  name                         = "my-sql-server-for-practise"
  resource_group_name          = azurerm_resource_group.my_rg.name
  location                     = azurerm_resource_group.my_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234"
}

resource "azurerm_sql_database" "my_sql_db" {
  name                   = "my-sql-db"
  resource_group_name    = azurerm_resource_group.my_rg.name
  location               = azurerm_resource_group.my_rg.location
  server_name            = azurerm_sql_server.my_sql_server.name


  tags = {
    environment = "development"
  }
}

