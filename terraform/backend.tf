terraform {
  backend "azurerm" {
    subscription_id      = "7bc4b637-e7b0-4cf5-8105-b46e1c86cb83"
    resource_group_name  = "rg-factory-mgmt"
    storage_account_name = "safactorymgmt"
    container_name       = "bootstrap-mgmt-state"
    key                  = "terraform.tfstate"
  }
}
