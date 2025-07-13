# variables.tf - Root module

variable "resource_group_name" {
  description = "Name of the resource group for terraform state"
  type        = string
}

variable "azurerm_storage_account_name" {
  description = "Prefix for the storage account name(wil be combined with random suffix)"
  type        = string
}


variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
}
