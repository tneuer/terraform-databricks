variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "pl_subnet_id" {
  type = string
}

variable "databricks_workspace_id" {
  type = string
}

variable "private_dns_zone_dnsuiapi_id" {
  type = string
}

variable "tags" {
  type = map(any)
}
