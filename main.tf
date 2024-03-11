terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.95.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azuread_application" "sp" {
  display_name               = var.name
  identifier_uris            = ["http://${var.name}"]
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.sp.client_id

  tags = ["aks", "terraform", var.name]
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
  end_date             = var.end_date
}

resource "azurerm_role_assignment" "assignments" {
  count                = length(var.assignments)
  scope                = var.assignments[count.index].scope
  role_definition_name = var.assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.sp.object_id
}
