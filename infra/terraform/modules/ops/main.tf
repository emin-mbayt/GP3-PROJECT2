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
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.ops.id]

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
