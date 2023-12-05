variable "location" {
}
variable "resourcegroup" {
}
variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}
variable "aks_cluster_name" {
  type = string
}
variable "acr_name" {
  type = string
}
variable "system_node_count" {
  description = "The number of system nodes for the AKS cluster"
  type        = number
}
variable "log_analytics_id" {
}
variable "service_principal_name" {
}
variable "client_id" {

}
variable "client_secret" {
  type = string
  sensitive = true
}