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