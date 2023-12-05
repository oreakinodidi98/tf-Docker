locals {
  tags = {
    environment = "demo"
    owner       = "Ore"
  }
}
#create resource group
resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourcegroup
  location = var.location
  tags     = local.tags
}
#call the aks module
module "aks" {
  source            = "./modules/aks"
  resourcegroup     = var.resourcegroup
  location          = var.location
  aks_cluster_name  = var.aks_cluster_name
  acr_name          = var.acr_name
  system_node_count = var.system_node_count
  log_analytics_id  = module.log_analytics.azurerm_log_analytics_workspace_id
  depends_on        = [azurerm_resource_group.resourcegroup]
}
module "log_analytics" {
  source                      = "./modules/logs"
  env_name                    = var.env_name
  location                    = var.location
  resourcegroup               = var.resourcegroup
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  depends_on                  = [azurerm_resource_group.resourcegroup]
}