terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.8.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "bc2c4117-7212-4afb-9e01-080bdcfd9ea4"
}
