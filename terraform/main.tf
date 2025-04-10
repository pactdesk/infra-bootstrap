module "resource_group" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/resource-group?ref=1c15e1bdf86e0b20b6a2669cf860ad16265dd5fd"

  name        = "projectfactory"
  environment = "mgmt"
  location    = "westeurope"
  managed_by  = "Terraform"

  tags = {
    managed_by_terraform = true
    purpose              = "terraform-state"
    critical             = "true"
  }
}

resource "azurerm_management_lock" "resource_group" {
  name       = "protect-terraform-state"
  scope      = module.resource_group.id
  lock_level = "CanNotDelete"
}

module "storage_account" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/storage-account?ref=1c15e1bdf86e0b20b6a2669cf860ad16265dd5fd"

  resource_group_name = module.resource_group.name
  name                = "projectfactory"
  environment         = "mgmt"
  location            = "westeurope"
  allowed_copy_scope  = "AAD"

  # Security settings
  min_tls_version = "TLS1_2"

  # Network settings
  public_network_access_enabled = true # TODO: Change to false when ready for production
  network_rules = {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    purpose              = "terraform-state"
    critical             = "true"
    managed_by_terraform = true
  }
}

module "storage_container_mgmt_state" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/storage-container?ref=1c15e1bdf86e0b20b6a2669cf860ad16265dd5fd"

  storage_account_id    = module.storage_account.id
  name                  = "mgmt-state"
  container_access_type = "private"
  metadata = {
    purpose     = "terraform-state"
    environment = "mgmt"
  }
}

module "storage_container_project_factory_state" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/storage-container?ref=1c15e1bdf86e0b20b6a2669cf860ad16265dd5fd"

  storage_account_id    = module.storage_account.id
  name                  = "projectfactory-state"
  container_access_type = "private"
  metadata = {
    purpose     = "terraform-state"
    environment = "mgmt"
  }
}
