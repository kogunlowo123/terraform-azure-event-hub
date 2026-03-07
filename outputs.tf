output "namespace_id" {
  description = "The ID of the Event Hub namespace."
  value       = azurerm_eventhub_namespace.this.id
}

output "namespace_name" {
  description = "The name of the Event Hub namespace."
  value       = azurerm_eventhub_namespace.this.name
}

output "namespace_default_primary_connection_string" {
  description = "The primary connection string for the namespace."
  value       = azurerm_eventhub_namespace.this.default_primary_connection_string
  sensitive   = true
}

output "namespace_default_primary_key" {
  description = "The primary access key for the namespace."
  value       = azurerm_eventhub_namespace.this.default_primary_key
  sensitive   = true
}

output "event_hub_ids" {
  description = "Map of Event Hub names to their IDs."
  value       = { for k, v in azurerm_eventhub.this : k => v.id }
}

output "event_hub_partition_ids" {
  description = "Map of Event Hub names to their partition IDs."
  value       = { for k, v in azurerm_eventhub.this : k => v.partition_ids }
}

output "consumer_group_ids" {
  description = "Map of consumer group keys to their IDs."
  value       = { for k, v in azurerm_eventhub_consumer_group.this : k => v.id }
}

output "authorization_rule_ids" {
  description = "Map of authorization rule names to their IDs."
  value       = { for k, v in azurerm_eventhub_namespace_authorization_rule.this : k => v.id }
}

output "private_endpoint_id" {
  description = "The ID of the private endpoint."
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].id : null
}

output "private_endpoint_ip_address" {
  description = "The private IP address of the private endpoint."
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address : null
}
