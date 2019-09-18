output "object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.sp.object_id
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.sp.application_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.sp.value
  sensitive   = true
}