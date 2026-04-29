# ── Data Collection Rule — syslog + perf metrics from all VMs ─────────────────

resource "azurerm_monitor_data_collection_rule" "main" {
  name                = "dcr-${local.prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags

  destinations {
    log_analytics {
      workspace_resource_id = module.observability.workspace_id
      name                  = "law-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["law-destination"]
  }

  data_sources {
    syslog {
      name           = "syslog"
      facility_names = ["*"]
      log_levels     = ["Warning", "Error", "Critical"]
      streams        = ["Microsoft-Syslog"]
    }

    performance_counter {
      name                          = "perf"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available Bytes",
      ]
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "web" {
  name                    = "dcra-web"
  target_resource_id      = module.compute.vm_web_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.main.id
}

resource "azurerm_monitor_data_collection_rule_association" "api" {
  name                    = "dcra-api"
  target_resource_id      = module.compute.vm_api_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.main.id
}

resource "azurerm_monitor_data_collection_rule_association" "ops" {
  name                    = "dcra-ops"
  target_resource_id      = module.ops.vm_ops_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.main.id
}

# ── Action Group ──────────────────────────────────────────────────────────────

resource "azurerm_monitor_action_group" "email" {
  name                = "ag-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "proj2alerts"
  tags                = local.tags

  email_receiver {
    name          = "team-email"
    email_address = var.alert_email
  }
}

# ── Alert 1: App Gateway Unhealthy Backend ────────────────────────────────────

resource "azurerm_monitor_metric_alert" "appgw_unhealthy" {
  name                = "alert-appgw-unhealthy-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [module.appgw.appgw_id]
  description         = "App Gateway has unhealthy backend hosts"
  severity            = 1
  window_size         = "PT5M"
  frequency           = "PT1M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

# ── Alert 2: VM CPU High ──────────────────────────────────────────────────────

resource "azurerm_monitor_metric_alert" "vm_cpu" {
  name                     = "alert-vm-cpu-${local.prefix}"
  resource_group_name      = azurerm_resource_group.main.name
  scopes                   = [module.compute.vm_web_id, module.compute.vm_api_id]
  description              = "VM CPU usage is high"
  severity                 = 2
  window_size              = "PT5M"
  frequency                = "PT1M"
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.location
  tags                     = local.tags

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

# ── Alert 3: SQL DTU High ─────────────────────────────────────────────────────

resource "azurerm_monitor_metric_alert" "sql_dtu" {
  name                = "alert-sql-dtu-${local.prefix}"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [module.data.sql_db_id]
  description         = "SQL DTU consumption is high"
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT1M"
  tags                = local.tags

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "dtu_consumption_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}
