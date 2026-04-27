locals {
  feip_name            = "feip-${var.prefix}"
  feport_http          = "feport-http"
  listener_http        = "listener-http"
  pool_frontend        = "pool-frontend"
  pool_backend         = "pool-backend"
  httpsetting_frontend = "httpsetting-frontend"
  httpsetting_backend  = "httpsetting-backend"
  probe_frontend       = "probe-frontend"
  probe_backend        = "probe-backend"
  urlmap               = "urlmap-${var.prefix}"
  routing_rule         = "rule-${var.prefix}"
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_web_application_firewall_policy" "main" {
  name                = "wafpol-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    max_request_body_size_in_kb = 128
    file_upload_limit_in_mb     = 100
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "appgw-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  firewall_policy_id = azurerm_web_application_firewall_policy.main.id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
    # capacity omitted — controlled by autoscale_configuration below
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "gwipconf"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = local.feip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.feport_http
    port = 80
    # TLS stretch goal: add frontend_port 443 here, an ssl_certificate block,
    # and update the http_listener below to protocol = "Https" + ssl_cert ref.
  }

  backend_address_pool {
    name         = local.pool_frontend
    ip_addresses = [var.frontend_private_ip]
  }

  backend_address_pool {
    name         = local.pool_backend
    ip_addresses = [var.backend_private_ip]
  }

  probe {
    name                                      = local.probe_frontend
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  probe {
    name                                      = local.probe_backend
    protocol                                  = "Http"
    path                                      = "/api/health"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {
    name                  = local.httpsetting_frontend
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = local.probe_frontend
  }

  backend_http_settings {
    name                  = local.httpsetting_backend
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = local.probe_backend
  }

  http_listener {
    name                           = local.listener_http
    frontend_ip_configuration_name = local.feip_name
    frontend_port_name             = local.feport_http
    protocol                       = "Http"
  }

  url_path_map {
    name                               = local.urlmap
    default_backend_address_pool_name  = local.pool_frontend
    default_backend_http_settings_name = local.httpsetting_frontend

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = local.pool_backend
      backend_http_settings_name = local.httpsetting_backend
    }
  }

  request_routing_rule {
    name               = local.routing_rule
    rule_type          = "PathBasedRouting"
    http_listener_name = local.listener_http
    url_path_map_name  = local.urlmap
    priority           = 100
  }
}

resource "azurerm_monitor_diagnostic_setting" "appgw" {
  name                       = "diag-appgw-${var.prefix}"
  target_resource_id         = azurerm_application_gateway.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
