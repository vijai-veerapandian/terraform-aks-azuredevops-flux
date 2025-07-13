# outputs.tf - Root module

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.tf_state.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.tf_state.name
}


