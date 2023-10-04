output "vm_public_ip" {
  description = "Public IP Address of the Virtual Machine"
  value       = azurerm_windows_virtual_machine.my_vm.public_ip_address
}

