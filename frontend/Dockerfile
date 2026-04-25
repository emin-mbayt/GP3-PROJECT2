# ==========================================
# Stage 1: Build Environment (Builder)
# ==========================================
# BEST PRACTICE 1: Pin exact versions (or SHA digests) to prevent upstream breaking changes
FROM node:20.12.0-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package manifests and install dependencies
# We do not set NODE_ENV=production yet because Vite needs devDependencies to build
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# ==========================================
# Stage 2: Secure Production Server
# ==========================================
# BEST PRACTICE 2: Use the official Nginx Unprivileged image
# This eliminates the need for manual `chown` commands and guarantees 
# everything (PID files, cache, etc.) is pre-configured to run as a non-root user.
FROM nginxinc/nginx-unprivileged:1.25-alpine

# Add metadata
LABEL maintainer="GROUP-3"
LABEL description="Docker image for secure and efficient deployment"

# BEST PRACTICE 3: Switch to the root user temporarily ONLY to clean up default files, 
# then immediately switch back to the unprivileged 'nginx' user.
USER root
RUN rm -rf /usr/share/nginx/html/*
USER nginx

# Copy built assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy your custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# BEST PRACTICE 4: Add a Docker Healthcheck
# This allows container orchestrators (like Docker Swarm or Kubernetes) to automatically 
# know if the web server has crashed internally, even if the container is technically "running".
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:3000/ || exit 1

# Expose the unprivileged port (must match the listen port in nginx.conf)
EXPOSE 3000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]