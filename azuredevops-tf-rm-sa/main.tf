# main.tf - Root module

resource "azurerm_resource_group" "tf_state" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Purpose     = "Terraform state storage"
  }
}


# Random string for additional uniqueness
resource "random_string" "suffix" {
  length  = 10
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tf_state" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.tf_state.name
  location                 = azurerm_resource_group.tf_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Purpose     = "Terraform state storage"
  }
}

resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tf_state.name
  container_access_type = "private"
}


