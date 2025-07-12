# outputs.tf - Root module outputs

output "vm_name" {
  description = "The name of the virtual machine."
  value       = var.vm_name
}

output "vm_public_ip" {
  description = "The public IP address of the virtual machine."
  value       = module.vm.public_ip_address
}

output "vm_fqdn" {
  description = "The fully qualified domain name of the virtual machine."
  value       = module.vm.fqdn
}

output "ssh_connection_string" {
  description = "The command to connect to the VM using SSH."
  value       = "ssh ${var.admin_username}@${module.vm.public_ip_address}"
}

output "vm_management_commands" {
  description = "Useful Azure CLI commands to manage the VM."
  value = {
    start   = "az vm start --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}"
    stop    = "az vm stop --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}"
    status  = "az vm show --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name} --show-details --query powerState"
    restart = "az vm restart --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}"
  }
}

output "cost_optimization_tips" {
  description = "Tips for optimizing the cost of this VM."
  value       = <<-EOT
    - The VM is configured with a ${var.vm_size} instance type.
    - VM auto shuts down at ${var.autoshutdown_time} UTC daily. You can change this with the 'autoshutdown_time' variable.
    - To stop the VM manually and deallocate compute resources, run: '${self.vm_management_commands.value.stop}'
  EOT
}

output "vm_principal_id" {
  description = "The principal ID of the system-assigned managed identity for the VM. Use this to grant the VM access to other Azure resources."
  value       = module.vm.vm_principal_id
  sensitive   = true
}
