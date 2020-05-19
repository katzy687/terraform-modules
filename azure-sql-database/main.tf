provider "azurerm" {
  version = "=2.9.0"
  features {}
}

data "azurerm_resource_group" "sandbox_rg" {
  name = var.SANDBOX_ID
}

resource "random_password" "db_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_sql_server" "default" {
  name                = "${var.SANDBOX_ID}-${var.SERVICE_NAME}-sqlsvr"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  version                      = "12.0"
  administrator_login          = var.DB_USERNAME
  administrator_login_password = random_password.db_password.result

  tags = data.azurerm_resource_group.sandbox_rg.tags
}

resource "azurerm_sql_database" "default" {
  name                = "${var.SERVICE_NAME}-db"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  server_name         = azurerm_sql_server.default.name
  edition             = "Basic"
  create_mode         = "Default"
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  tags = data.azurerm_resource_group.sandbox_rg.tags
}

output "connection_string" {
  value = "Server=tcp:${azurerm_sql_server.default.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.default.name};Persist Security Info=False;User ID=${var.DB_USERNAME};Password=${random_password.db_password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
