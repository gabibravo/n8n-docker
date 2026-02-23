# WARNING: This Dockerfile is for reference only.
# Digital Ocean App Platform does NOT support docker-compose within containers.
# 
# For App Platform deployment, use the docker-compose.yml directly on a Droplet.
# See DEPLOY_DIGITAL_OCEAN.md for instructions.

# This is a minimal Dockerfile that shows app structure
# It cannot run docker-compose inside the container

FROM node:20-alpine

WORKDIR /app

# Label indicating this should be deployed via Droplet, not App Platform
LABEL description="n8n - Use Droplet deployment, not App Platform"

COPY . .

# Create a startup script that explains the limitation
RUN echo '#!/bin/sh\n\
echo "===================================="\n\
echo "Docker Compose not supported here"\n\
echo "===================================="\n\
echo ""\n\
echo "Digital Ocean App Platform does NOT support:"\n\
echo "  - Docker-in-Docker (DinD)"\n\
echo "  - docker-compose within containers"\n\
echo ""\n\
echo "For this project, use DROPLET deployment instead:"\n\
echo "  1. Create a Droplet (Ubuntu 22.04 LTS, $6/mes)"\n\
echo "  2. Install Docker and Docker Compose"\n\
echo "  3. Clone the repository"\n\
echo "  4. Run: docker-compose up -d"\n\
echo ""\n\
echo "See DEPLOY_DIGITAL_OCEAN.md for instructions"\n\
exit 1\n\
' > /app/start.sh && chmod +x /app/start.sh

EXPOSE 5678

CMD ["/app/start.sh"]

