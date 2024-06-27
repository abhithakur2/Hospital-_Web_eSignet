# Define Azure provider
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

# Define variables
variable "resource_group_name" {
  default = "esignet"
}

variable "vm_name" {
  default = "esignet"
}

variable "network_name" {
  default = "esignet"
}

variable "vm_username" {
  default = "<userName >"  ##userName
}

variable "vm_password" {
  default = "<passoword>" ### <passoword
}

# Create resource group
resource "azurerm_resource_group" "esignet" {
  name     = var.resource_group_name
  location = "Central India"  # Change to your desired region
}

# Create virtual network
resource "azurerm_virtual_network" "esignet" {
  name                = var.network_name
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.esignet.location
  resource_group_name = azurerm_resource_group.esignet.name
}

# Create subnet
resource "azurerm_subnet" "esignet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.esignet.name
  virtual_network_name = azurerm_virtual_network.esignet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create public IP address
resource "azurerm_public_ip" "esignet" {
  name                = "publicip"
  location            = azurerm_resource_group.esignet.location
  resource_group_name = azurerm_resource_group.esignet.name
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "esignet" {
  name                = "esignet_nic"
  location            = azurerm_resource_group.esignet.location
  resource_group_name = azurerm_resource_group.esignet.name

  ip_configuration {
    name                          = "esignet-nic-config"
    subnet_id                     = azurerm_subnet.esignet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.esignet.id
  }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "esignet" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.esignet.name
  location              = azurerm_resource_group.esignet.location
  size                  = "Standard_DS2_v2"
  admin_username        = var.vm_username
  disable_password_authentication = false
  admin_password        = var.vm_password
  network_interface_ids = [azurerm_network_interface.esignet.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Create network security group
resource "azurerm_network_security_group" "esignet" {
  name                = "esignet-nsg"
  location            = azurerm_resource_group.esignet.location
  resource_group_name = azurerm_resource_group.esignet.name
  
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
  security_rule {
    name                       = "http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "https"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  
  # You can add more security rules here for other ports and protocols as needed
}


# Output public IP address, VM username, and password
output "public_ip_address" {
  value = azurerm_public_ip.esignet.ip_address
}

output "vm_username" {
  value = var.vm_username
}

output "vm_password" {
  value = var.vm_password
}
