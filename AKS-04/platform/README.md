# Platform Configuration: OpenShift 4.x + ECK

## Overview

Platform-specific configurations for deploying AKS-04 on Red Hat OpenShift Container Platform.

## Files

- `scc.yaml - Security Context Constraints`
- `route.yaml - OpenShift Routes`
- `machineset-example.yaml - Dedicated node pool`
- `resource-quota.yaml - Namespace quotas`

## Prerequisites

### OpenShift 4.x + ECK

See individual files for specific requirements.

## Usage

Apply platform-specific resources before deploying Elasticsearch:

```bash
kubectl apply -f platform/openshift/
```

Then deploy the main Elasticsearch cluster:

```bash
kubectl apply -k elasticsearch/
```
