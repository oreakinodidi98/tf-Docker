variable "resourcegroup" {
  description = "value for resourcegroup"
  type        = string
  default     = "rg-docker-01"
}
variable "location" {
  description = "value for location"
  type        = string
  default     = "UK South"
}
variable "naming_prefix" {
  description = "The naming prefix for all resources in this example"
  type        = string
  default     = "docker"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    environment = "demo"
    owner       = "Ore Akin"
    description = "GH actions docker Demo"
  }
}
variable "aks_cluster_name" {
  type    = string
  default = "tf-aks-dev"
}
variable "acr_name" {
  type    = string
  default = "tf-acr-dev"
}
variable "system_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
  default     = 2
}
variable "env_name" {
  description = "Name of Environment"
  type        = string
  default     = "tf-docker-demo"
}
variable "log_analytics_workspace_sku" {
  description = "The pricing SKU of the Log Analytics workspace."
  default     = "PerGB2018"
}