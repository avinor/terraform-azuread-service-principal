terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azuread_application" "sp" {
  display_name               = var.name
  identifier_uris            = ["http://${var.name}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id

  tags = ["aks", "terraform", var.name]
}

resource "random_string" "unique" {
  length  = 32
  special = false
  upper   = true

  keepers = {
    service_principal = azuread_service_principal.sp.id
  }
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
  value                = random_string.unique.result
  end_date             = var.end_date
}

resource "azurerm_role_assignment" "assignments" {
  count                = length(var.assignments)
  scope                = var.assignments[count.index].scope
  role_definition_name = var.assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.sp.object_id
}
