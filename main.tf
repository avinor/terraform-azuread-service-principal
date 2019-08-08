terraform {
  required_version = ">= 0.12.0"
}

resource "azuread_application" "sp" {
  name                       = var.name
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
}

resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
  value                = random_string.unique.result
  end_date             = var.end_date
}

resource "azurerm_role_assignment" "acr" {
  count                = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_role_assignment" "subnet" {
  count                = length(var.subnet_id)
  scope                = var.subnet_id[count.index]
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_role_assignment" "storage" {
  count                = length(var.storage_id)
  scope                = var.storage_id[count.index]
  role_definition_name = "Storage Account Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}