variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type = string
}

variable "subnet_ops_id" {
  description = "Subnet ID for the ops VM NIC."
  type        = string
}

variable "vm_admin_password" {
  description = "Password for the azureuser account on all VMs."
  type        = string
  sensitive   = true
}

variable "vm_size_ops" {
  description = "VM size for the ops VM."
  type        = string
}
