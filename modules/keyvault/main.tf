data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                        = var.keyvault_name
    location                    = var.location
    resource_group_name         = var.resourcegroup
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    purge_protection_enabled    = false
    soft_delete_retention_days = 7
    enable_rbac_authorization = true
    sku_name = "premium"
    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  }
}

resource "azurerm_key_vault_access_policy" "kv_runner_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = var.service_principal_tenant_id
  object_id = var.service_principal_object_id
  key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
}
resource "azurerm_role_assignment" "gh_actions" {
  scope              = azurerm_key_vault.kv.id
  principal_id       = var.service_principal_object_id
  role_definition_name = "Key Vault Administrator"
}
