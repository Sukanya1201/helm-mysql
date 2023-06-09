provider "azurerm"{
    features{}
}
# Create a resource group if it doesn't exist

resource "azurerm_resource_group" "hostterraformgroup11" {
    name     = var.rg_name
    location = "Central India"

    tags = {
        environment = "Terraform Host"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "hostterraformnetwork11" {
    name                = var.vnet_name
    address_space       = ["10.0.0.0/16"]
    location            = "Central India"
    resource_group_name = azurerm_resource_group.hostterraformgroup11.name

    tags = {
        environment = "Terraform Host"
    }
}

# Create subnet
resource "azurerm_subnet" "hostterraformsubnet11" {
    name                 = var.subnet_name
    resource_group_name  = azurerm_resource_group.hostterraformgroup11.name
    virtual_network_name = azurerm_virtual_network.hostterraformnetwork11.name
    address_prefixes       = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.AzureActiveDirectory","Microsoft.AzureCosmosDB","Microsoft.ContainerRegistry","Microsoft.EventHub","Microsoft.KeyVault","Microsoft.ServiceBus","Microsoft.Sql","Microsoft.Storage","Microsoft.Web"]
}
# Create public IPs
resource "azurerm_public_ip" "hostterraformpublicip11" {
    name                         = var.public_ip_name
    location                     = "Central India"
    resource_group_name          = azurerm_resource_group.hostterraformgroup11.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Host"
    }
}


# Create network interface
resource "azurerm_network_interface" "hostterraformnic11" {
    name                      = var.nic_name
    location                  = "Central India"
    resource_group_name       = azurerm_resource_group.hostterraformgroup11.name

    ip_configuration {
        name                          = var.ipconfig_name
        subnet_id                     = azurerm_subnet.hostterraformsubnet11.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.hostterraformpublicip11.id
    }

    tags = {
        environment = "Terraform Host"
    }
}




# Create virtual machine
resource "azurerm_linux_virtual_machine" "hostterraformvm11" {
    name                  = var.vm_name
    location              = "Central India"
    resource_group_name   = azurerm_resource_group.hostterraformgroup11.name
    network_interface_ids = [azurerm_network_interface.hostterraformnic11.id]
    size                  = var.vm_size

    os_disk {
        name              = var.os_disk
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    computer_name  = var.computer_name
    admin_username = var.admin_username
    disable_password_authentication = false
    admin_password = var.admin_password

    

    tags = {
        environment = "Terraform Host"
    }
   
}



