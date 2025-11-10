variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}
