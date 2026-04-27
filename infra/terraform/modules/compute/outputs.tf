output "vm_web_private_ip" {
  description = "Frontend VM private IP (consumed by appgw module)."
  value       = azurerm_network_interface.web.private_ip_address
}

output "vm_api_private_ip" {
  description = "Backend VM private IP (consumed by appgw module)."
  value       = azurerm_network_interface.api.private_ip_address
}

output "vm_web_principal_id" {
  description = "System-assigned managed identity principal ID for the frontend VM."
  value       = azurerm_linux_virtual_machine.web.identity[0].principal_id
}

output "vm_api_principal_id" {
  description = "System-assigned managed identity principal ID for the backend VM."
  value       = azurerm_linux_virtual_machine.api.identity[0].principal_id
}
