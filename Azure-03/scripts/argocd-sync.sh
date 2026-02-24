#!/usr/bin/env bash
# ArgoCD sync script for Azure-03

set -euo pipefail

ENV="${1:-dev}"
APP_NAME="Azure-03-$ENV"

echo "Syncing $APP_NAME..."

if command -v argocd &> /dev/null; then
    argocd app sync "$APP_NAME" --prune
    argocd app wait "$APP_NAME" --health
else
    echo "ArgoCD CLI not found. Using kubectl..."
    kubectl patch application "$APP_NAME" -n argocd \
        --type merge \
        -p '{"operation": {"initiatedBy": {"username": "script"}, "sync": {"prune": true}}}'
fi

echo "Sync complete!"
