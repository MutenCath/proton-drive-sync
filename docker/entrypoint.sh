#!/bin/bash
set -e

# Ensure persistent and data directories exist
mkdir -p /config/proton-drive-sync /state/proton-drive-sync /data

# Check if authenticated; if not, start dashboard only so user can auth via exec
if ! proton-drive-sync status > /dev/null 2>&1; then
    echo "Not authenticated yet. Starting dashboard for initial setup..."
    echo "Run: kubectl exec -it <pod> -n proton-drive-sync -- proton-drive-sync auth"
    exec proton-drive-sync dashboard --no-open "$@"
fi

# Start sync in foreground (no daemon mode)
echo "Starting Proton Drive Sync..."
exec proton-drive-sync start --no-daemon "$@"
