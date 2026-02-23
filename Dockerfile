# Use Docker Compose as the base
# This Dockerfile is designed for Digital Ocean App Platform
# It will start Docker Compose when the container starts

FROM docker:24-dind

# Install Docker Compose
RUN apk add --no-cache docker-compose bash curl

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Make scripts executable
RUN chmod +x scripts/*.sh *.sh 2>/dev/null || true

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Expose ports
EXPOSE 80 443 5678 5432 6379

# Start Docker Compose
CMD ["docker-compose", "up"]
