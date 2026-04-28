# ── Frontend VM ───────────────────────────────────────────────────────────────

resource "azurerm_network_interface" "web" {
  name                = "nic-web-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconf-web"
    subnet_id                     = var.subnet_web_id
    private_ip_address_allocation = "Dynamic"
    # No public IP — ingress only via App Gateway
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  name                            = "vm-web-${var.prefix}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size_web
  admin_username                  = "azureuser"
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.web.id]

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

# ── Backend VM ────────────────────────────────────────────────────────────────

resource "azurerm_network_interface" "api" {
  name                = "nic-api-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconf-api"
    subnet_id                     = var.subnet_api_id
    private_ip_address_allocation = "Dynamic"
    # No public IP — ingress only via App Gateway
  }
}

resource "azurerm_linux_virtual_machine" "api" {
  name                            = "vm-api-${var.prefix}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size_api
  admin_username                  = "azureuser"
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.api.id]

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
