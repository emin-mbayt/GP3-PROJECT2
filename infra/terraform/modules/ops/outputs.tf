output "vm_ops_private_ip" {
  description = "Ops VM private IP (for Ansible inventory generation)."
  value       = azurerm_network_interface.ops.private_ip_address
}

output "vm_ops_name" {
  description = "Ops VM name (for Ansible inventory generation)."
  value       = azurerm_linux_virtual_machine.ops.name
}
