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

variable "subnet_web_id" {
  description = "Subnet ID for the frontend VM NIC."
  type        = string
}

variable "subnet_api_id" {
  description = "Subnet ID for the backend VM NIC."
  type        = string
}

variable "vm_admin_password" {
  description = "Password for the azureuser account on all VMs."
  type        = string
  sensitive   = true
}

variable "vm_size_web" {
  description = "VM size for the frontend VM."
  type        = string
}

variable "vm_size_api" {
  description = "VM size for the backend VM."
  type        = string
}
