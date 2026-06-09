resource "azurerm_public_ip" "main" {
  name                = "pip-${var.application_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.public_dns_label
  tags                = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = "agw-${var.application_name}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.app_gateway_subnet_id
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "publicIpConfig"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  ssl_certificate {
    name                = "appGatewayCert"
    key_vault_secret_id = var.ssl_certificate_secret_id
  }

  backend_address_pool {
    name = "appServicePool"

    backend_addresses {
      ip_address = var.app_service_private_ip
    }
  }

  backend_http_settings {
    name                           = "httpsSettings"
    port                           = 443
    protocol                       = "Https"
    host_name                      = var.app_service_default_hostname
    request_timeout                = 30
    pick_host_name_from_backend_address = false
  }

  probe {
    name                = "appServiceProbe"
    protocol            = "Https"
    host                = var.app_service_default_hostname
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = true
  }

  http_listener {
    name                           = "httpsListener"
    frontend_ip_configuration_name = "publicIpConfig"
    frontend_port_name             = "httpsPort"
    protocol                       = "Https"
    ssl_certificate_name           = "appGatewayCert"
  }

  request_routing_rule {
    name                       = "httpsRule"
    rule_type                  = "Basic"
    http_listener_name         = "httpsListener"
    backend_address_pool_name  = "appServicePool"
    backend_http_settings_name = "httpsSettings"
  }

  waf_configuration {
    enabled            = true
    firewall_mode      = "Prevention"
    rule_set_type      = "OWASP"
    rule_set_version   = "3.2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
