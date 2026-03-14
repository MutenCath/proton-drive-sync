#!/bin/bash
set -e

# Ensure persistent and data directories exist
mkdir -p /config/proton-drive-sync /state/proton-drive-sync /data

# Check if credentials exist; if not, start dashboard only so user can auth via exec
CRED_FILE="/config/proton-drive-sync/credentials.enc"
if [ ! -f "$CRED_FILE" ]; then
    echo "No credentials found at $CRED_FILE"
    echo "Starting dashboard for initial setup..."
    echo "Run: kubectl exec -it <pod> -n proton-drive-sync -- proton-drive-sync auth"
    # Keep the container alive with the dashboard
    proton-drive-sync dashboard "$@" || true
    # If dashboard exits, sleep to prevent crash loop
    echo "Dashboard exited. Sleeping to prevent crash loop. Please exec into the pod to authenticate."
    exec sleep infinity
fi

# Start sync in foreground (no daemon mode)
echo "Starting Proton Drive Sync..."
exec proton-drive-sync start --no-daemon "$@"
