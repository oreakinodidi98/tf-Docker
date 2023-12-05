#output acr id
output "acr_id" {
    description = "value for acr id"
    value = azurerm_container_registry.acr.id
}
# out put acr name 
output "acr_name" {
    description = "value for acr name"
    value = azurerm_container_registry.acr.name
}
#output aks name
output "aks_name" {
    description = "value for aks name"
    value = azurerm_kubernetes_cluster.aks.name
}
#output acr login server
output "acr_login_server" {
    description = "value for acr login server"
    value = azurerm_container_registry.acr.login_server
}
#output aks object id
output "aks_object_id" {
    description = "value for output of the object ID of the kubelet identity"
    value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
#output aks service principal object id
output "aks_id" {
    description = "value for aks id"
    value = azurerm_kubernetes_cluster.aks.id
}
#output aks fqdn
output "aks_fqdn" {
    description = "value for aks fqdn"
    value = azurerm_kubernetes_cluster.aks.fqdn
}
#output aks node resource group
output "aks_node_resource_group" {
    description = "value for aks node resource group"
    value = azurerm_kubernetes_cluster.aks.node_resource_group
}
# kube config local file system 
resource "local_file" "kubeconfig" {
    content  = azurerm_kubernetes_cluster.aks.kube_config_raw
    #filename = "kubeconfig"
    filename = local.client_certificate_path
    depends_on = [azurerm_kubernetes_cluster.aks]
}
output "managed_identity_client_id" {
  description = "The Client ID of the Managed Identity"
  value       = azurerm_role_assignment.role_acrpull.principal_id
}
locals {
  client_certificate_path = "${abspath(path.module)}/azurek8s.crt"
  kube_config_path        = "${abspath(path.module)}/azurek8s.config"
}
resource "local_file" "client_certificate" {
  content  = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  filename = local.client_certificate_path
   depends_on = [azurerm_kubernetes_cluster.aks]
}
output "kube_config_path" {
  value = local.kube_config_path
}

output "recommend_kube_config" {
  value = <<EOF
  # run this command in bash to use the new AKS clusters
export KUBECONFIG=${local.kube_config_path}
# or in PowerShell
$KUBECONFIG = "${local.kube_config_path}"
EOF
}
