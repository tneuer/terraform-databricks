variable "location" {
  type = string
}

variable "project" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "db_public_subnet_name" {
  type = string
}

variable "db_private_subnet_name" {
  type = string
}

variable "db_public_subnet_network_security_group_association_id" {
  type = string
}

variable "db_private_subnet_network_security_group_association_id" {
  type = string
}

variable "db_storage_account_name" {
  type = string
}

variable "tags" {
  type = map(any)
}
