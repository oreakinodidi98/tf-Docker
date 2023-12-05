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
#call the service principal module
module "service_principal" {
  source                 = "./modules/spn"
  service_principal_name = var.service_principal_name
  owner_username         = var.owner_username
  depends_on             = [azurerm_resource_group.resourcegroup]
}
resource "azurerm_role_assignment" "role_rg" {
  scope                = module.service_principal.subscription_scope
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.sp_object_id
  depends_on           = [module.service_principal]
}
#call the keyvault module
module "keyvault" {
  source                      = "./modules/keyvault"
  location                    = var.location
  resourcegroup               = var.resourcegroup
  keyvault_name               = var.keyvault_name
  service_principal_object_id = module.service_principal.sp_object_id
  service_principal_tenant_id = module.service_principal.sp_tenant_id
  service_principal_name      = var.service_principal_name
  depends_on                  = [module.service_principal]
}
resource "azurerm_key_vault_secret" "example" {
  name         = module.service_principal.app_app_id
  value        = module.service_principal.arm_client_secret
  key_vault_id = module.keyvault.key_vault_id

  depends_on = [module.keyvault]
}
#call the aks module
module "aks" {
  source                 = "./modules/aks"
  resourcegroup          = var.resourcegroup
  location               = var.location
  aks_cluster_name       = var.aks_cluster_name
  acr_name               = var.acr_name
  system_node_count      = var.system_node_count
  log_analytics_id       = module.log_analytics.azurerm_log_analytics_workspace_id
  service_principal_name = var.service_principal_name
  client_id              = module.service_principal.app_app_id
  client_secret          = module.service_principal.arm_client_secret
  depends_on             = [module.service_principal]
}
#call the log analytics module
module "log_analytics" {
  source                      = "./modules/logs"
  env_name                    = var.env_name
  location                    = var.location
  resourcegroup               = var.resourcegroup
  log_analytics_workspace_sku = var.log_analytics_workspace_sku
  depends_on                  = [module.service_principal]
}

