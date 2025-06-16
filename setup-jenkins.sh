#!/bin/bash

echo "🚀 Setting up Jenkins for CloudTaskPro CI/CD Pipeline Demo"
echo "=========================================================="

# Create jenkins directory structure
mkdir -p jenkins/jenkins_home
mkdir -p jenkins/docker

# Create Jenkins Dockerfile
cat > jenkins/Dockerfile << 'EOF'
FROM jenkins/jenkins:lts

# Switch to root to install Docker
USER root

# Install Docker
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Python3 and pip
RUN apt-get install -y python3 python3-pip

# Switch back to jenkins user
USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "docker-workflow:1.29 pipeline-stage-view:2.25 git:4.8.3 workflow-aggregator:2.6 blueocean:1.25.2 docker-plugin:1.2.6"
EOF

# Create Jenkins Docker Compose
cat > jenkins/docker-compose.yml << 'EOF'
services:
  jenkins:
    build: .
    container_name: jenkins-cicd
    ports:
      - "8085:8080"
      - "50000:50000"
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - ../:/var/jenkins_home/workspace/cloudtaskpro
    environment:
      - DOCKER_HOST=unix:///var/run/docker.sock
    restart: unless-stopped
EOF

# Create Jenkins configuration script
cat > jenkins/configure-jenkins.sh << 'EOF'
#!/bin/bash

echo "🔧 Jenkins Configuration Helper"
echo "================================"
echo ""
echo "After Jenkins starts, you'll need to:"
echo ""
echo "1. 📋 Get the initial admin password:"
echo "   docker exec jenkins-cicd cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "2. 🌐 Open Jenkins in browser:"
echo "   http://localhost:8085"
echo ""
echo "3. 📦 Install suggested plugins"
echo ""
echo "4. 👤 Create admin user"
echo ""
echo "5. 🔗 Create a new Pipeline job:"
echo "   - New Item > Pipeline"
echo "   - Name: CloudTaskPro-CI-CD"
echo "   - Pipeline > Definition: Pipeline script from SCM"
echo "   - SCM: Git"
echo "   - Repository URL: /var/jenkins_home/workspace/cloudtaskpro"
echo "   - Script Path: Jenkinsfile"
echo ""
echo "6. 🚀 Run the pipeline!"
EOF

chmod +x jenkins/configure-jenkins.sh

# Create docker-compose for the entire demo
cat > docker-compose.demo.yml << 'EOF'
services:
  # Jenkins CI/CD Server
  jenkins:
    build: ./jenkins
    container_name: jenkins-cicd
    ports:
      - "8085:8080"
      - "50000:50000"
    volumes:
      - ./jenkins/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - .:/var/jenkins_home/workspace/cloudtaskpro
    environment:
      - DOCKER_HOST=unix:///var/run/docker.sock
    restart: unless-stopped

  # Application Services (for testing)
  frontend:
    build:
      context: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:8080
    stdin_open: true
    tty: true

  backend:
    build:
      context: ./backend
    ports:
      - "8080:8080"
    env_file:
      - ./backend/.env
    depends_on:
      - mongo

  mongo:
    image: mongo:5.0
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
EOF

echo "✅ Jenkins setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Build and start Jenkins:"
echo "   cd jenkins && docker-compose up -d"
echo ""
echo "2. Configure Jenkins:"
echo "   ./jenkins/configure-jenkins.sh"
echo ""
echo "3. Or start everything together:"
echo "   docker-compose -f docker-compose.demo.yml up -d"
echo ""
echo "🎯 Ports:"
echo "   - Jenkins: http://localhost:8085"
echo "   - App Frontend: http://localhost:3000"
echo "   - App Backend: http://localhost:8080"
echo "   - MongoDB: localhost:27017" 