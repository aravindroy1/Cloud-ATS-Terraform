data "azuread_client_config" "current" {}

resource "azuread_application" "main" {
  display_name     = var.display_name
  sign_in_audience = var.sign_in_audience
  owners           = [data.azuread_client_config.current.object_id]

  web {
    homepage_url  = var.homepage_url
    logout_url    = var.logout_url
    redirect_uris = var.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  api {
    requested_access_token_version = 2
  }
}

resource "azuread_service_principal" "main" {
  client_id                    = azuread_application.main.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "main" {
  application_id = azuread_application.main.id
  display_name   = "cloudats-appservice"
}

