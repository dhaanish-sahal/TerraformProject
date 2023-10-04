variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"  # Change to your desired region
}

variable "vm_username" {
  description = "Virtual Machine Username"
  type        = string
  default     = "youradminuser"  # Change to your desired username
}

variable "vm_password" {
  description = "Virtual Machine Password"
  type        = string
}

# Add more variables as needed

