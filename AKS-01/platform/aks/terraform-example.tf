# Terraform example: AKS node pools derived from sizing export
# Add these resources to your AKS Terraform configuration.
resource "azurerm_kubernetes_cluster_node_pool" "eshot" {
  name                  = "eshot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_E16s_v5"
  node_count            = 3

  # Elasticsearch
  enable_auto_scaling = true
  min_count           = 3
  max_count           = 6

  zones = ["1", "2", "3"]

  node_labels = {
    "workload"                 = "elasticsearch"
    "AKS-01-pool" = "eshot"
  }

  node_taints = [
    "elasticsearch=true:NoSchedule"
  ]

  os_disk_size_gb = 1000
  os_disk_type    = "Managed"

  tags = {
    Environment = "production"
    Project     = "AKS-01"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "escold" {
  name                  = "escold"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D16s_v5"
  node_count            = 3

  # Elasticsearch
  enable_auto_scaling = true
  min_count           = 3
  max_count           = 6

  zones = ["1", "2", "3"]

  node_labels = {
    "workload"                 = "elasticsearch"
    "AKS-01-pool" = "escold"
  }

  node_taints = [
    "elasticsearch=true:NoSchedule"
  ]

  os_disk_size_gb = 2000
  os_disk_type    = "Managed"

  tags = {
    Environment = "production"
    Project     = "AKS-01"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "esfrozen" {
  name                  = "esfrozen"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_F32s_v2"
  node_count            = 3

  # Elasticsearch
  enable_auto_scaling = true
  min_count           = 3
  max_count           = 6

  zones = ["1", "2", "3"]

  node_labels = {
    "workload"                 = "elasticsearch"
    "AKS-01-pool" = "esfrozen"
  }

  node_taints = [
    "elasticsearch=true:NoSchedule"
  ]

  os_disk_size_gb = 128
  os_disk_type    = "Managed"

  tags = {
    Environment = "production"
    Project     = "AKS-01"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D16s_v5"
  node_count            = 3

  # Elasticsearch
  enable_auto_scaling = true
  min_count           = 3
  max_count           = 6

  zones = ["1", "2", "3"]

  node_labels = {
    "workload"                 = "elasticsearch"
    "AKS-01-pool" = "system"
  }

  node_taints = [
    "elasticsearch=true:NoSchedule"
  ]

  os_disk_size_gb = 128
  os_disk_type    = "Managed"

  tags = {
    Environment = "production"
    Project     = "AKS-01"
  }
}

output "elasticsearch_node_pool_ids" {
  value = {
    eshot = azurerm_kubernetes_cluster_node_pool.eshot.id
    escold = azurerm_kubernetes_cluster_node_pool.escold.id
    esfrozen = azurerm_kubernetes_cluster_node_pool.esfrozen.id
    system = azurerm_kubernetes_cluster_node_pool.system.id
  }
}
