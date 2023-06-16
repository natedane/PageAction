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
  
  lifecycle {
    prevent_destroy = true
  } 
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
   
  lifecycle {
    prevent_destroy = true
  }  
 
}
# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "main-container" {
  depends_on = [azurerm_storage_account.state-sta]   
  name = "tf-state"
  storage_account_name = azurerm_storage_account.state-sta.name
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "myappservice-plan"
  location            = azurerm_resource_group.state-rg.location
  resource_group_name = azurerm_resource_group.state-rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "nateApp"
  location            = azurerm_resource_group.state-rg.location
  resource_group_name = azurerm_resource_group.state-rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

}