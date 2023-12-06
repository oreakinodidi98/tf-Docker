resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.env_name}-loga"
  location            = var.location
  resource_group_name = var.resourcegroup
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [
      name,
    ]
  }
}
resource "azurerm_log_analytics_solution" "aks-containerinsights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.aks.location
  resource_group_name   = var.resourcegroup
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id
  workspace_name        = azurerm_log_analytics_workspace.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
resource "azurerm_application_insights" "insight" {
  name                = "tf-containerinsights"
  location            = azurerm_log_analytics_workspace.aks.location
  resource_group_name = var.resourcegroup
  application_type    = "web"
  retention_in_days = 30
}