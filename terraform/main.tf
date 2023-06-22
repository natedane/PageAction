terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.15.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "rg_tfstorage"
    storage_account_name = "satfstorage2023"
    container_name = "tf-state"
    key = "terraform.tfstate"
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}
provider "azuread" {
  tenant_id = var.ARM_TENANT_ID
  alias     = "ad"
}

# Generate a random storage name
resource "random_string" "tf-name" {
  length = 8
  upper = false
  numeric = true
  lower = true
  special = false
}
# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "state-rg" {
  name = "rg_tfstorage"
  location = var.location
}
# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "state-sta" {
  depends_on = [azurerm_resource_group.state-rg]  
  name = "satfstorage2023"
  resource_group_name = azurerm_resource_group.state-rg.name
  location = azurerm_resource_group.state-rg.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier = "Cool"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
 
 
}
# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "main-container" {
  depends_on = [azurerm_storage_account.state-sta]   
  name = "tf-state"
  storage_account_name = azurerm_storage_account.state-sta.name
}

resource "azurerm_service_plan" "service_plan" {
  name                = "myappservice-plan"
  location            = var.location_sp
  resource_group_name = azurerm_resource_group.state-rg.name
  os_type = "Linux"
  sku_name = "F1"

}

resource "azurerm_linux_web_app" "app" {
  name                = "nateapp-2023619"
  location            = var.location_sp
  resource_group_name = azurerm_resource_group.state-rg.name
  service_plan_id      = azurerm_service_plan.service_plan.id
  https_only            = true
  site_config { 
    application_stack {
      node_version      = "16-lts"
    }
    always_on = false
    use_32_bit_worker = true

  }
}