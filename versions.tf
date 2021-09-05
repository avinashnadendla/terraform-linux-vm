terraform {
    required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      version = ">=2.75.0"
     }
  }
}
provider "azurerm" {
  features {
  }
}