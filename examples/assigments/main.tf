module "service_principal" {
  source = "../../"

  name     = "simple-sp"
  end_date = "2020-01-01T00:00:00Z"

  assignments = [
    {
      scope                = "/subscriptions/xxxx/"
      role_definition_name = "Contributor"
    },
  ]
}