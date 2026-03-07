# terraform-azure-event-hub

Terraform module for Azure Event Hubs with namespaces, event hubs, consumer groups, authorization rules, capture, and network rules.

## Architecture

```mermaid
flowchart TB
    subgraph EH["Azure Event Hubs"]
        NS[Namespace] --> H1[Event Hub 1]
        NS --> H2[Event Hub 2]
        H1 --> CG1[Consumer Group]
        H1 --> CG2[Consumer Group]
        H1 --> CAP[Capture to Storage]
    end

    subgraph Security["Security"]
        AR[Authorization Rules]
        NR[Network Rules]
        PE[Private Endpoint]
    end

    subgraph Consumers["Consumers"]
        FA[Azure Functions]
        SA[Stream Analytics]
        APP[Applications]
    end

    EH --> Security
    CG1 --> Consumers
    CG2 --> Consumers

    style EH fill:#0078D4,color:#fff
    style Security fill:#DD344C,color:#fff
    style Consumers fill:#3F8624,color:#fff
```

## Usage

```hcl
module "event_hub" {
  source = "github.com/kogunlowo123/terraform-azure-event-hub"

  namespace_name      = "my-eventhub-ns"
  resource_group_name = "rg-eventhub"
  location            = "East US"
  sku                 = "Standard"

  event_hubs = {
    orders = {
      partition_count   = 4
      message_retention = 7
    }
  }

  tags = { Environment = "production" }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| azurerm | >= 3.80.0 |

## License

MIT Licensed. See [LICENSE](LICENSE) for details.
