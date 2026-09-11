#!/usr/bin/env bash

set -Eeuo pipefail

SOURCE="/home/beynz/projects/portfolio"
DEST="/srv/www/portfolio"
BACKUP_DIR="/home/beynz/backups/portfolio"
LOG="/home/beynz/logs/portfolio-deploy.log"
SITE="https://beynz.uk"

TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP="$BACKUP_DIR/portfolio-$TIMESTAMP.tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

log "Starting portfolio deployment"

cd "$SOURCE"

# Don't deploy unfinished/uncommitted work
if ! git diff --quiet || ! git diff --cached --quiet; then
    log "ERROR: Git working tree contains uncommitted changes."
    exit 1
fi

# Make sure required website files exist
if [[ ! -f "$SOURCE/index.html" ]]; then
    log "ERROR: index.html not found."
    exit 1
fi

if [[ ! -d "$SOURCE/assets" ]]; then
    log "ERROR: assets directory not found."
    exit 1
fi

# Back up the currently deployed website
log "Creating pre-deployment backup"

tar -C "$DEST" -czf "$BACKUP" .

# Deploy an explicit allow-list of public files
log "Deploying website"

sudo rsync -a \
    --delete \
    --delete-excluded \
    --include='/index.html' \
    --include='/assets/' \
    --include='/assets/***' \
    --include='/projects/' \
    --include='/projects/***' \
    --exclude='*' \
    "$SOURCE/" "$DEST/"

# Verify public website
log "Checking public website"

if curl --fail --silent --show-error --max-time 15 "$SITE" > /dev/null; then
    log "SUCCESS: Portfolio deployed and $SITE returned successfully."
else
    log "ERROR: Website health check failed."
    log "Rolling back previous deployment."

    sudo rm -rf "${DEST:?}/"*
    sudo tar -C "$DEST" -xzf "$BACKUP"

    log "ROLLBACK COMPLETE"
    exit 1
fi

# Keep the five most recent backups
ls -1t "$BACKUP_DIR"/portfolio-*.tar.gz 2>/dev/null \
    | tail -n +6 \
    | xargs -r rm --

log "Deployment complete"
