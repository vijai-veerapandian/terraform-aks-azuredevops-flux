# locals.tf - Root module local variables

locals {
  vm_management_commands = {
    start   = "az vm start --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}"
    stop    = "az vm deallocate --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}" # Use deallocate to stop billing for compute
    status  = "az vm show --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name} --show-details --query powerState"
    restart = "az vm restart --resource-group ${azurerm_resource_group.main.name} --name ${var.vm_name}"
  }
}
