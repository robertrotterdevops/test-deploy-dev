# ArgoCD Configuration: Azure-03

## Overview

This directory contains ArgoCD Application and AppProject manifests for GitOps-based deployments.

## Structure

```
argocd/
├── namespace.yaml      # ArgoCD namespace
├── appproject.yaml     # AppProject definition
├── application.yaml    # Main application
├── apps/
│   ├── root-app.yaml   # App-of-apps root
│   ├── dev-app.yaml    # Dev environment
│   ├── staging-app.yaml
│   └── production-app.yaml
└── README.md
```

## Prerequisites

1. ArgoCD installed in the cluster:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. ArgoCD CLI installed (optional):
   ```bash
   brew install argocd  # macOS
   ```

## Deployment

### Bootstrap (first time)

```bash
# Apply AppProject first
kubectl apply -f argocd/appproject.yaml

# Apply root app (app-of-apps)
kubectl apply -f argocd/apps/root-app.yaml
```

### Access ArgoCD UI

```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then visit: https://localhost:8080

## Environments

| Environment | Auto-sync | Namespace |
|-------------|-----------|-----------|
| dev | Yes | Azure-03-dev |
| staging | Yes | Azure-03-staging |
| production | No (manual) | Azure-03-production |

## Sync Applications

### Via CLI

```bash
# Sync dev
argocd app sync Azure-03-dev

# Sync all
argocd app sync Azure-03-apps
```

### Via Script

```bash
./scripts/argocd-sync.sh dev
./scripts/argocd-sync.sh staging
./scripts/argocd-sync.sh production
```

## RBAC

Two roles are defined in the AppProject:
- **developer**: Can view and sync applications
- **admin**: Full control over applications and repositories
