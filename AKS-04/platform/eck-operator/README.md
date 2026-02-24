# ECK Operator

This directory contains Flux-managed ECK operator resources.

- Version: `2.16.0`
- Namespace: `elastic-system`

Deploy order:
1. CRDs (`crds.yaml` via remote URL)
2. Operator (`operator.yaml`)

Validate:
```bash
kubectl get crd | grep k8s.elastic.co
kubectl -n elastic-system get pods
```
