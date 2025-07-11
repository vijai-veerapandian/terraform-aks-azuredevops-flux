# outputs.tf - Root Module Outputs

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Network Module Outputs
output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = module.network.subnet_name
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = module.network.subnet_id
}

output "network_security_group_name" {
  description = "Name of the network security group"
  value       = module.network.network_security_group_name
}

# VM Module Outputs
output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.vm.vm_name
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = module.vm.vm_id
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = module.vm.public_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = module.vm.private_ip_address
}

output "vm_fqdn" {
  description = "Fully qualified domain name of the virtual machine"
  value       = module.vm.fqdn
}

# Connection Information
output "ssh_connection_command" {
  description = "Command to SSH into the virtual machine"
  value       = "ssh ${var.admin_username}@${module.vm.public_ip_address}"
}

output "vm_management_commands" {
  description = "Commands to manage the virtual machine"
  value = {
    start   = "az vm start --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name}"
    stop    = "az vm stop --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name}"
    status  = "az vm show --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name} --show-details --query powerState"
    restart = "az vm restart --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name}"
  }
}

# DevOps Agent Setup Information
output "agent_setup_instructions" {
  description = "Instructions for setting up the Azure DevOps agent"
  value       = <<-EOT
    1. SSH into the VM: ssh ${var.admin_username}@${module.vm.public_ip_address}
    2. Change to agent directory: cd /opt/devops-agent
    3. Run setup script: ./setup-agent.sh
    4. Follow the prompts to configure your Azure DevOps agent
    5. Check agent status: sudo ./svc.sh status
  EOT
}

# Cost Optimization Information
output "cost_optimization_tips" {
  description = "Tips for optimizing costs"
  value       = <<-EOT
    Cost Optimization Tips:
    - VM auto shuts down at ${var.auto_shutdown_time} daily
    - Stop VM when not in use: az vm stop --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name}
    - Start VM when needed: az vm start --resource-group ${azurerm_resource_group.main.name} --name ${module.vm.vm_name}
    - Monitor costs in Azure portal
  EOT
}
