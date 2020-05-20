provider "azurerm" {
  version = "=2.9.0"
  features {}
}

data "azurerm_resource_group" "sandbox_rg" {
  name = var.SANDBOX_ID
}

data "azurerm_app_service_plan" "plan" {
  name                = var.PLAN_NAME
  resource_group_name = var.PLAN_RG
}

locals {
    webapp_name = "${var.SERVICE_NAME}-${var.SANDBOX_ID}"
}

resource "azurerm_app_service" "webapp" {
  name                = local.webapp_name
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  app_service_plan_id = data.azurerm_app_service_plan.plan.id

  site_config {
    # app_command_line = ""
    dotnet_framework_version = "v4.0"
    ip_restriction = []
  }

#   app_settings = {
#     "SOME_KEY" = "some-value"
#   }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = var.CONNECTION_STRING
  }

  tags = data.azurerm_resource_group.sandbox_rg.tags
}

resource "null_resource" "deploy_code" {
  count = var.DEPLOY_CODE ? 1 : 0

  depends_on = [azurerm_app_service.webapp]
 
  provisioner "local-exec" {
        command = "chmod 777 deploy_code.sh && ./deploy_code.sh '${data.azurerm_resource_group.sandbox_rg.name}' '${local.webapp_name}' '${var.ARTIFACTS_SA}' '${var.ARTIFACT_PATH}'"
        interpreter = ["/bin/bash", "-c"]
  }
}

output "endpoint" {
  value = "https://${azurerm_app_service.webapp.default_site_hostname}"
}

# output "tag1" {
#   value = data.azurerm_resource_group.sandbox_rg.tags.colony-blueprint-name
# }

