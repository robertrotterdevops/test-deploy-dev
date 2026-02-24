# Elasticsearch Cluster: Azure-02

## Overview

ECK-managed Elasticsearch cluster with the following components:
- **Elasticsearch 8.17.0**: 6 nodes (multi-tier architecture)
- **Kibana 8.17.0**: 1 instance(s) for visualization
- **Elastic Agent**: Fleet-managed for log/metric collection

## Sizing Source

This cluster was sized using the **elasticsearch-openshift-sizing-assistant**.
- **Health Score**: N/A/100
- **Profile**: Multi-tier (Hot/Cold/Frozen)

## Prerequisites

1. ECK Operator installed (v2.16.0+):
   ```bash
   kubectl create -f https://download.elastic.co/downloads/eck/2.16.0/crds.yaml
   kubectl apply -f https://download.elastic.co/downloads/eck/2.16.0/operator.yaml
   ```

2. Storage classes available:
   - `premium` for hot tier
   - `standard` for cold/frozen tiers

## Deployment

```bash
# Apply all manifests
kubectl apply -k elasticsearch/

# Or apply individually
kubectl apply -f elasticsearch/namespace.yaml
kubectl apply -f elasticsearch/cluster.yaml
kubectl apply -f elasticsearch/kibana.yaml
kubectl apply -f elasticsearch/agent.yaml
```

## Access

### Get Elasticsearch password
```bash
kubectl get secret Azure-02-es-elastic-user -n Azure-02 -o jsonpath='{{.data.elastic}}' | base64 -d
```

### Port-forward Elasticsearch
```bash
kubectl port-forward svc/Azure-02-es-http -n Azure-02 9200:9200
```

### Port-forward Kibana
```bash
kubectl port-forward svc/Azure-02-kb-http -n Azure-02 5601:5601
```

## Node Configuration

| Component | Count | Memory | CPU | Storage |
|-----------|-------|--------|-----|---------|
| Master nodes | 3 | 2Gi | 1 | - |
| Hot tier | 3 | 8Gi | 2 | 100Gi |
| Frozen tier | 1 | 32Gi | 8 | 2400Gi (cache) |
| Kibana | 1 | 2Gi | 1 | - |

## ILM Policies

The `hot-cold-frozen` policy is included for log lifecycle management:
- Hot: 0-7 days (rollover at 1d or 50GB)
- Cold: 7-30 days (allocate to cold nodes, read-only)
- Frozen: 30-365 days (searchable snapshots)
- Delete: 365+ days

Apply with:
```bash
curl -X PUT "https://localhost:9200/_ilm/policy/hot-cold-frozen" \
  -H "Content-Type: application/json" \
  -u "elastic:$PASSWORD" \
  -d @elasticsearch/ilm-policies/hot-cold-frozen.json
```
