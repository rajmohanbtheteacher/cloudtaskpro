FROM jenkins/jenkins:lts

# Switch to root to install packages
USER root

# Install basic tools and Docker CLI (without Docker daemon)
RUN apt-get update && \
    apt-get install -y curl wget gnupg lsb-release python3 python3-pip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI from Docker's official repository (ARM64 compatible)
RUN curl -fsSL https://get.docker.com | sh

# Switch back to jenkins user
USER jenkins

# Skip plugin installation for now - we'll do it manually
# RUN jenkins-plugin-cli --plugins "docker-workflow pipeline-stage-view git workflow-aggregator blueocean"
