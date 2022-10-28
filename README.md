# Service Principal

Module to create a service principal and assign it certain roles. This used to
be `terraform-azurerm-kubernetes-service-principal` but is now made more generic so it can create any service
principals. It will output the application id and password that can be used for input in other modules.

This module requires elevated access to be able to create the application in AzureAD and assign roles to resources. It
is therefore not recommended to be run as any CI/CD pipeline, but instead manually before running any automated process.
The output can still be used by reading remote state.

## Usage

```terraform
module "simple" {
  source  = "avinor/service-principal/azurerm"
  version = "3.0.0"

  name = "simple-sp"

  assignments = [
    {
      scope                = "/subscriptions/xxxx/"
      role_definition_name = "Contributor"
    },
  ]
}
```
