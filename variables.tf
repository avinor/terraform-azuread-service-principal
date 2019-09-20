variable "name" {
  description = "Name of the service principal."
}

variable "end_date" {
  description = "The End Date which the Password is valid until, formatted as a RFC3339 date string (e.g. 2018-01-01T01:02:03Z)."
  default     = null
}

variable "assignments" {
  description = "List of role assignments this service principal should have."
  type = list(object({ scope = string, role_definition_name = string }))
  default = []
}
