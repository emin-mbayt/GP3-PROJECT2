resource "azurerm_network_interface" "ops" {
  name                = "nic-ops-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconf-ops"
    subnet_id                     = var.subnet_ops_id
    private_ip_address_allocation = "Dynamic"
    # No public IP — reach via Bastion or temporarily allow your IP via nsg-ops.
  }
}

resource "azurerm_linux_virtual_machine" "ops" {
  name                            = "vm-ops-${var.prefix}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size_ops
  admin_username                  = "azureuser"
  disable_password_authentication = true
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.ops.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}
