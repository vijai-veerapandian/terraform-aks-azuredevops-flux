# outputs.tf - VM module outputs file

output "vm_id" {
  description = "The ID of the virtual machine."
  value       = azurerm_linux_virtual_machine.main.id
}

output "vm_principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_linux_virtual_machine.main.identity[0].principal_id
}

output "public_ip_address" {
  description = "The public IP address of the virtual machine."
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip_address" {
  description = "The private IP address of the virtual machine."
  value       = azurerm_network_interface.main.private_ip_address
}
