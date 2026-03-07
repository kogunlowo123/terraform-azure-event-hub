#--------------------------------------------------------------
# Event Hub Namespace
#--------------------------------------------------------------
resource "azurerm_eventhub_namespace" "this" {
  name                     = local.namespace_name
  location                 = local.location
  resource_group_name      = data.azurerm_resource_group.this.name
  sku                      = var.sku
  capacity                 = var.capacity
  auto_inflate_enabled     = var.auto_inflate_enabled
  maximum_throughput_units  = var.auto_inflate_enabled ? var.maximum_throughput_units : null
  zone_redundant           = var.zone_redundant

  tags = local.merged_tags
}

#--------------------------------------------------------------
# Event Hubs
#--------------------------------------------------------------
resource "azurerm_eventhub" "this" {
  for_each = var.event_hubs

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = data.azurerm_resource_group.this.name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention

  dynamic "capture_description" {
    for_each = each.value.capture != null ? [each.value.capture] : []

    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = capture_description.value.interval_in_seconds
      size_limit_in_bytes = capture_description.value.size_limit_in_bytes
      skip_empty_archives = capture_description.value.skip_empty_archives

      destination {
        name                 = capture_description.value.destination.name
        archive_name_format  = capture_description.value.destination.archive_name_format
        blob_container_name  = capture_description.value.destination.blob_container_name
        storage_account_id   = capture_description.value.destination.storage_account_id
      }
    }
  }
}

#--------------------------------------------------------------
# Consumer Groups
#--------------------------------------------------------------
resource "azurerm_eventhub_consumer_group" "this" {
  for_each = local.consumer_groups_map

  name                = each.value.cg_key
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this[each.value.hub_key].name
  resource_group_name = data.azurerm_resource_group.this.name
  user_metadata       = each.value.user_metadata
}

#--------------------------------------------------------------
# Namespace Authorization Rules
#--------------------------------------------------------------
resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  for_each = var.authorization_rules

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = data.azurerm_resource_group.this.name
  listen              = each.value.listen
  send                = each.value.send
  manage              = each.value.manage
}

#--------------------------------------------------------------
# Private Endpoint
#--------------------------------------------------------------
resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                = "${local.namespace_name}-pe"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.namespace_name}-psc"
    private_connection_resource_id = azurerm_eventhub_namespace.this.id
    subresource_names              = ["namespace"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []

    content {
      name                 = "default"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }

  tags = local.merged_tags
}
