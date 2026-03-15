resource "azurerm_resource_group" "test" {
  name     = "rg-eventhub-test"
  location = "eastus2"
}

module "test" {
  source = "../"

  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  namespace_name      = "evhns-test-namespace"

  sku      = "Standard"
  capacity = 1

  event_hubs = {
    events = {
      partition_count   = 4
      message_retention = 7

      consumer_groups = {
        processor = {
          user_metadata = "Event processor consumer group"
        }
      }
    }
    telemetry = {
      partition_count   = 2
      message_retention = 1
    }
  }

  authorization_rules = {
    sender = {
      listen = false
      send   = true
      manage = false
    }
    listener = {
      listen = true
      send   = false
      manage = false
    }
  }

  private_endpoint_enabled = false

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
  }
}
