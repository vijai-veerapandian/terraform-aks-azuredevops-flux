# variables.tf - VM Module variables

variable "resource_group_name" {
  description = "The name of the resource group in which to create the VM."
  type        = string
}

variable "location" {
  description = "The Azure region where the VM will be created."
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key file."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to which the VM's network interface will be attached."
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of the network security group to associate with the VM's network interface."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "auto_shutdown_time" {
  description = "The time for the VM to automatically shut down (HHMM format)."
  type        = string
}

variable "azp_url" {
  description = "The URL of the Azure DevOps organization."
  type        = string
}

variable "azp_pool" {
  description = "The name of the Azure DevOps agent pool to join."
  type        = string
}

variable "azp_token" {
  description = "The Personal Access Token (PAT) for agent registration."
  type        = string
  sensitive   = true
}
