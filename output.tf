#output resource group name 
output "resource_group_name" {
  value = azurerm_resource_group.resourcegroup.name
}
output "acr_name" {
  value = module.aks.acr_name
}
output "aks_name" {
  value = module.aks.aks_name
}
output "kube_config_path" {
  value = module.aks.kube_config_path
}
output "managed_identity_client_id" {
  value = module.aks.managed_identity_client_id
}
output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.service_principal.app_app_id
}
output "client_secret" {
  description = "Password for service principal."
  value       = module.service_principal.arm_client_secret
  sensitive   = true

}