###################applicaion output ##########################
output "app_object_id" {
    description = "value for application object id"
  value = azuread_application.gh_actions.object_id
}
output "app_app_id" {
    description = "value for application id"
  value = azuread_application.gh_actions.application_id
  #value       = azuread_application.gh_actions.application_object_id
}
output "app_name" {
    description = "value for application name"
  value = azuread_application.gh_actions.display_name
}
###########################service principal output ##########################
output "sp_object_id" {
    description = "value for service principal object id"
  value = azuread_service_principal.gh_actions.object_id
}
output "sp_tenant_id" {
    description = "value for service principal tenant id"
  value = azuread_service_principal.gh_actions.application_tenant_id
}
output "arm_client_id" {
    description = "value for service principal application id"
  value = azuread_service_principal.gh_actions.application_id
}
output "sp_name" {
    description = "value for service principal name"
    value = azuread_service_principal.gh_actions.display_name
}
###################service principal password output ##########################
output "arm_client_secret" {
  description = "value for service principal client secret"
  value = azuread_service_principal_password.aks_sp_password.value
  sensitive = true
}
###########################role assignment output ##########################
output "arm_subscribtion_id" {
    description = "value for subscription id"
    value = data.azurerm_subscription.current.subscription_id
}
output "arm_tenant_id" {
    description = "value for tenant id"
    value = data.azuread_client_config.current.tenant_id
}
output "subscription_scope" {
    description = "value for subscription scope"
    value = data.azurerm_subscription.current.id
}


