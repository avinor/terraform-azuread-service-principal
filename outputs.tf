output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.sp.application_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.sp.value
  sensitive   = true
}