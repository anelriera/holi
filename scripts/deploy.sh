#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load .env from project root
ENV_FILE="$PROJECT_DIR/.env"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: .env file not found at $ENV_FILE"
  echo "Copy .env.example to .env and fill in your values."
  exit 1
fi
source "$ENV_FILE"

# Validate required variables
for var in VPS_HOST VPS_USER; do
  if [[ -z "${!var:-}" ]]; then
    echo "Error: $var is not set in .env"
    exit 1
  fi
done

DEPLOY_PATH="${VPS_DEPLOY_PATH:-apps/cositas}"

# Resolve to absolute path on the remote (~ expanded remotely)
REMOTE_PATH=$(ssh -o StrictHostKeyChecking=no "${VPS_USER}@${VPS_HOST}" "cd ~ && mkdir -p ${DEPLOY_PATH} && cd ${DEPLOY_PATH} && pwd")

echo "Deploying to ${VPS_USER}@${VPS_HOST}:${REMOTE_PATH} ..."

rsync -avz --delete \
  --exclude '.git' \
  --exclude '.github' \
  --exclude '.claude' \
  --exclude '.env' \
  --exclude '.env.example' \
  --exclude 'scripts' \
  -e "ssh -o StrictHostKeyChecking=no" \
  "$PROJECT_DIR/" \
  "${VPS_USER}@${VPS_HOST}:${REMOTE_PATH}/"

echo "Deploy complete."
