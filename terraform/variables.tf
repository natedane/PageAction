
# environment
variable "environment" {
  type = string
  description = "This variable defines the environment to be built"
}

# azure region
variable "location" {
  type = string
  description = "Azure region where resources will be created"
  default = "centralus"
}

# azure tenant id
variable "MICROSOFT_PROVIDER_AUTHENTICATION_TENANT_ID" {
  type = string
  description = "id for tenant"
  sensitive = true
}

# common name
variable "common" {
  type = string
  description = "common name to use"
  default = "nated"
}

# Define Terraform provider
terraform {
  required_version = ">= 1.3"
  backend "azurerm" {
    resource_group_name  = "${var.common}-tfstate-rg"
    storage_account_name =  "${lower(var.common)}tf${random_string.tf-name.result}"
    container_name       = "main-tfstate"
    key                  = "actions.tfstate"
  }
  required_providers {
    azurerm = {
      version = "~>3.2"
      source  = "hashicorp/azurerm"
    }
  }
}
# Configure the Azure provider
provider "azurerm" { 
  features {}  
}