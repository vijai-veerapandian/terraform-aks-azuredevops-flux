# variables.tf - Root module variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-devops-pool-agent"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "Canada Central", "Canada East"
    ], var.location)
    error_message = "Location must be a valid Azure region"
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "The environment variable must be one of: dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "pool-agent"
}

# NW Variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-pool-agent"
}


variable "vnet_address_space" {
  description = "Address space for the virtual machine"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-pool-agent"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}


variable "allowed_ssh_ips" {
  description = "List of IP address/CIDR blocks allowed to ssh to the VM"
  type        = list(string)
  # Removing the default makes this a required variable, preventing accidental
  # exposure of the VM to the entire internet. This is a security best practice.
}

#VM Variables

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "vm-pool-agent"
}

variable "vm_size" {
  description = "size of the VM"
  type        = string
  default     = "Standard_B2s" # 2 vCPUs, 4GB RAM - optimal for devops pool agent

  validation {
    condition = contains([
      "Standard_B1s", "Standard_B1ms", "Standard_B2s", "Standard_B2ms",
      "Standard_B4ms", "Standard_D2s_v3", "Standard_D4s_v3"
    ], var.vm_size)
    error_message = "VM size must be one of the supported sizes for pool agents."
  }
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.admin_username))
    error_message = "Admin username must start with a lowercase letter and can only contain lowercase letters, numbers, and underscores."
  }
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "./.ssh/ssh-key-aks-cluster-ubuntu.pub"

  validation {
    condition     = fileexists(var.ssh_public_key_path)
    error_message = "Specified SSH public key file doesn't exist at the provided path."
  }
}


variable "autoshutdown_time" {
  description = "Time to auto shutdown the VM (24-hr format)"
  type        = string
  default     = "2300"

  validation {
    condition     = can(regex("^([01]?[0-9]|2[0-3])[0-5][0-9]$", var.autoshutdown_time))
    error_message = "The auto_shutdown_time variable must be in a valid 24-hour format (e.g., 0930 or 2300)."
  }
}

# Azure DevOps Agent Variables
variable "azp_url" {
  description = "The URL of the Azure DevOps organization (e.g., https://dev.azure.com/my-org)."
  type        = string
}

variable "azp_pool" {
  description = "The name of the Azure DevOps agent pool to join."
  type        = string
  default     = "Default"
}

variable "azp_token" {
  description = "The Personal Access Token (PAT) for agent registration."
  type        = string
  sensitive   = true
}
