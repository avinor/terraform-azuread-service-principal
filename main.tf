terraform {
  required_version = ">= 0.13"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.28.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azuread_application" "sp" {
  display_name     = var.name
  identifier_uris  = ["http://${var.name}"]
  sign_in_audience = "AzureADMyOrg"

  web {
    homepage_url = "https://${var.name}"
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  lifecycle {
    ignore_changes = [owners, api]
  }
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id
  tags           = ["aks", "terraform", var.name]

  lifecycle {
    ignore_changes = [owners]
  }
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
  end_date             = var.end_date
}

resource "azurerm_role_assignment" "assignments" {
  count = length(var.assignments)

  scope                = var.assignments[count.index].scope
  role_definition_name = var.assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.sp.object_id
}
