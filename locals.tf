locals {
  namespace_name = var.namespace_name
  location       = var.location

  # Flatten consumer groups across all event hubs
  consumer_groups = flatten([
    for hub_key, hub in var.event_hubs : [
      for cg_key, cg in hub.consumer_groups : {
        hub_key       = hub_key
        cg_key        = cg_key
        user_metadata = cg.user_metadata
      }
    ]
  ])

  consumer_groups_map = {
    for cg in local.consumer_groups : "${cg.hub_key}-${cg.cg_key}" => cg
  }

  # Event hubs with capture enabled
  event_hubs_with_capture = {
    for k, v in var.event_hubs : k => v if v.capture != null
  }

  default_tags = {
    ManagedBy = "Terraform"
    Module    = "terraform-azure-event-hub"
  }

  merged_tags = merge(local.default_tags, var.tags)
}
