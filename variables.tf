variable "name" {
  description = "Name of the service principal."
}

variable "end_date" {
  description = "The End Date which the Password is valid until, formatted as a RFC3339 date string (e.g. 2018-01-01T01:02:03Z)."
  default     = null
}

variable "acr_id" {
  description = "Id of Azure Container Registry to grant access to."
  default     = null
}

variable "subnet_id" {
  description = "List of ids of virtual network subnet to grant Network Contributer access to if using advanced networking."
  type        = list(string)
  default     = []
}

variable "storage_id" {
  description = "List of storage account ids to grant Storage Account Contributor access to."
  type        = list(string)
  default     = []
}
