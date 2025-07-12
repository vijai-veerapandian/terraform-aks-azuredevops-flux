# modules/vm/main.tf - VM Module

# Create Public IP
resource "azurerm_public_ip" "main" {
  name                = "pip-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = lower(var.vm_name)
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Module      = "vm"
  }
}

# Create Network Interface
resource "azurerm_network_interface" "main" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    Environment = var.environment
    Module      = "vm"
  }
}

# Associate the Network Security Group with the Network Interface
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = var.network_security_group_id
}

# Create Ubuntu Linux Virtual Machine for Azure DevOps Agent
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  # Disable password authentication for security
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS" # SSD for better performance
    disk_size_gb         = 64            # Sufficient space for tools and builds
  }

  # Ubuntu 22.04 LTS (Jammy Jellyfish) - Latest LTS Version
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  # Custom script to install DevOps tools
  custom_data = base64encode(templatefile("${path.module}/scripts/install-devops-tools.sh", {
    admin_username = var.admin_username,
    azp_url        = var.azp_url,
    azp_token      = var.azp_token,
    azp_pool       = var.azp_pool
  }))

  tags = {
    Environment = var.environment
    Module      = "vm"
    Purpose     = "Azure DevOps Agent"
    OS          = "Ubuntu 22.04 LTS"
  }
}

# Auto-shutdown configuration (optional - saves costs)
resource "azurerm_dev_test_global_vm_shutdown_schedule" "main" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.auto_shutdown_time
  timezone              = "UTC"

  notification_settings {
    enabled = false
  }

  tags = {
    Environment = var.environment
    Module      = "vm"
  }
}
