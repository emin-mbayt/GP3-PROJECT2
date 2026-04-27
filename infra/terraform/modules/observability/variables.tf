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

variable "retention_days" {
  description = "Log Analytics data retention in days (30 for dev, 90+ for prod)."
  type        = number
  default     = 30
}
