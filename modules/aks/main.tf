# get latest azure AKS latest Version
data "azurerm_kubernetes_service_versions" "versions" {
    location = var.location
    include_preview = false
}
#create role assignment for acr
resource "azurerm_role_assignment" "role_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.service_principal[0].client_id
  skip_service_principal_aad_check = true
}
#create acr
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resourcegroup
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}
# create AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resourcegroup
  dns_prefix          = "${var.resourcegroup}-cluster"
  kubernetes_version = data.azurerm_kubernetes_service_versions.versions.latest_version
  node_resource_group = "${var.resourcegroup}-node-rg"

  default_node_pool {
    name       = "system"
    node_count = var.system_node_count
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = false
    #availability_zones = ["1","2","3"]
    temporary_name_for_rotation = "newnode1"
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels         = {
      "nodepool" = "system"
      "env"      = "dev"
      "nodepools" = "linux"
    }
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  oms_agent {
        log_analytics_workspace_id = var.log_analytics_id
  }
  tags = {
      "nodepool" = "system"
      "env"      = "demo"
  }
network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    }
    linux_profile {
      admin_username = "ubuntu"
      ssh_key {
        key_data = file(var.ssh_public_key)
      }
    }
}