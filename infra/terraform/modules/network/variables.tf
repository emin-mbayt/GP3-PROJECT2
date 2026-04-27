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

variable "admin_source_cidr" {
  description = "CIDR block allowed SSH into the ops NSG."
  type        = string
}
