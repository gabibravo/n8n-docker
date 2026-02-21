#!/bin/bash

# View n8n logs

set -e

SERVICE=${1:-n8n}

echo "Showing logs for: $SERVICE"
docker-compose logs -f $SERVICE
