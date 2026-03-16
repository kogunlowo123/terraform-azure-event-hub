variable "resource_group_name" {
  description = "Name of the resource group for Event Hub resources."
  type        = string
}

variable "location" {
  description = "Azure region for the Event Hub namespace."
  type        = string
}

variable "namespace_name" {
  description = "Name of the Event Hub namespace."
  type        = string
}

variable "sku" {
  description = "SKU tier for the Event Hub namespace (Basic, Standard, or Premium)."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "capacity" {
  description = "Throughput units for the namespace."
  type        = number
  default     = 1
}

variable "auto_inflate_enabled" {
  description = "Enable auto-inflate for the namespace."
  type        = bool
  default     = false
}

variable "maximum_throughput_units" {
  description = "Maximum throughput units when auto-inflate is enabled."
  type        = number
  default     = 0
}

variable "zone_redundant" {
  description = "Enable zone redundancy for the namespace."
  type        = bool
  default     = false
}

variable "event_hubs" {
  description = "Map of Event Hubs to create within the namespace."
  type = map(object({
    partition_count   = optional(number, 2)
    message_retention = optional(number, 1)
    consumer_groups = optional(map(object({
      user_metadata = optional(string, null)
    })), {})
    capture = optional(object({
      enabled             = bool
      encoding            = optional(string, "Avro")
      interval_in_seconds = optional(number, 300)
      size_limit_in_bytes = optional(number, 314572800)
      skip_empty_archives = optional(bool, false)
      destination = object({
        name                = optional(string, "EventHubArchive.AzureBlockBlob")
        archive_name_format = string
        blob_container_name = string
        storage_account_id  = string
      })
    }), null)
  }))
  default = {}
}

variable "authorization_rules" {
  description = "Map of namespace-level authorization rules."
  type = map(object({
    listen = optional(bool, false)
    send   = optional(bool, false)
    manage = optional(bool, false)
  }))
  default = {}
}

variable "private_endpoint_enabled" {
  description = "Enable private endpoint for the Event Hub namespace."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the private endpoint."
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for the private endpoint."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}
