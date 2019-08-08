output "application_id" {
  description = "The application id of AzureAD application created."
  value = azuread_application.sp.application_id
}

output "password" {
  description = "Password for service principal."
  value = random_string.unique.result
}