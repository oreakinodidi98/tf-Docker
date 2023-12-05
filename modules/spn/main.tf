# Terraform module for creating a service principal

data "azuread_client_config" "current" {}
data "azuread_user" "owner" {
    user_principal_name = var.owner_username
}
data "azurerm_subscription" "current" {}

locals {
        app_owners = [
        data.azuread_client_config.current.object_id,
        data.azuread_user.owner.object_id
]
}

resource "azuread_application" "gh_actions" {
    display_name = var.service_principal_name
    owners       = local.app_owners
}

resource "azuread_service_principal" "gh_actions" {
    client_id                    = azuread_application.gh_actions.client_id
    owners                       = local.app_owners
    app_role_assignment_required = true
}

resource "azuread_service_principal_password" "aks_sp_password" {
    display_name         = "aks_sp_password"
    service_principal_id = azuread_service_principal.gh_actions.object_id
}

resource "azuread_application_password" "aks_sp_app_password" {
    application_id = azuread_application.gh_actions.object_id
}
