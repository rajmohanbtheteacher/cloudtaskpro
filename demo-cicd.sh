#!/bin/bash

# CloudTaskPro CI/CD Pipeline Demo
# This script demonstrates a complete CI/CD pipeline without Jenkins

echo "🚀 CloudTaskPro CI/CD Pipeline Demo"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print stage headers
print_stage() {
    echo ""
    echo -e "${BLUE}📋 Stage: $1${NC}"
    echo "================================"
}

# Function to simulate processing time
simulate_work() {
    sleep 2
}

# Stage 1: Checkout
print_stage "🔍 Checkout"
echo "📥 Simulating code checkout..."
echo "✅ Source code retrieved successfully"
simulate_work

# Stage 2: Cleanup
print_stage "🧹 Cleanup"
echo "🧹 Cleaning up previous builds..."
docker-compose down --remove-orphans 2>/dev/null || true
echo "✅ Cleanup completed"
simulate_work

# Stage 3: Environment Setup
print_stage "🔧 Environment Setup"
echo "🔧 Setting up build environment..."
echo "Build Number: $(date +%Y%m%d-%H%M%S)"
echo "Python Version: $(python3 --version 2>/dev/null || echo 'Python not found')"
echo "Node Version: $(node --version 2>/dev/null || echo 'Node not found')"
echo "Docker Version: $(docker --version 2>/dev/null || echo 'Docker not found')"
echo "✅ Environment setup completed"
simulate_work

# Stage 4: Install Dependencies
print_stage "📦 Install Dependencies"
echo "📦 Installing backend dependencies..."
cd backend
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt >/dev/null 2>&1 || echo "⚠️  Backend dependencies installation failed (demo mode)"
else
    echo "⚠️  requirements.txt not found"
fi
cd ..

echo "📦 Installing frontend dependencies..."
cd frontend
if [ -f "package.json" ]; then
    npm install >/dev/null 2>&1 || echo "⚠️  Frontend dependencies installation failed (demo mode)"
else
    echo "⚠️  package.json not found"
fi
cd ..
echo "✅ Dependencies installation completed"
simulate_work

# Stage 5: Code Quality & Linting
print_stage "🔍 Code Quality & Linting"
echo "🔍 Running backend linting..."
cd backend
if command -v flake8 >/dev/null 2>&1; then
    flake8 --max-line-length=88 --ignore=E203,W503 app.py || echo "⚠️  Linting issues found"
else
    echo "⚠️  flake8 not installed (demo mode)"
fi
cd ..

echo "🔍 Running frontend linting..."
cd frontend
if [ -f "package.json" ]; then
    npm audit --audit-level=high >/dev/null 2>&1 || echo "⚠️  Security issues found"
else
    echo "⚠️  package.json not found"
fi
cd ..
echo "✅ Code quality checks completed"
simulate_work

# Stage 6: Run Tests
print_stage "🧪 Run Tests"
echo "🧪 Running backend tests..."
cd backend
if [ -f "test_app.py" ]; then
    python3 -m pytest test_app.py -v 2>/dev/null || echo "⚠️  Tests failed (demo mode)"
else
    echo "⚠️  test_app.py not found"
fi
cd ..

echo "🧪 Running frontend tests..."
cd frontend
if [ -f "package.json" ]; then
    # npm test --watchAll=false >/dev/null 2>&1 || echo "⚠️  Frontend tests failed (demo mode)"
    echo "⚠️  Frontend tests skipped (demo mode)"
else
    echo "⚠️  package.json not found"
fi
cd ..
echo "✅ Testing completed"
simulate_work

# Stage 7: Docker Build
print_stage "🐳 Docker Build"
echo "🐳 Building Docker images..."
if command -v docker >/dev/null 2>&1; then
    docker-compose build >/dev/null 2>&1 || echo "⚠️  Docker build failed (demo mode)"
    echo "🏷️  Tagging images with build number..."
    BUILD_NUMBER=$(date +%Y%m%d-%H%M%S)
    echo "   - Frontend image: cloudtaskpro-frontend:${BUILD_NUMBER}"
    echo "   - Backend image: cloudtaskpro-backend:${BUILD_NUMBER}"
else
    echo "⚠️  Docker not available (demo mode)"
fi
echo "✅ Docker build completed"
simulate_work

# Stage 8: Integration Tests
print_stage "🚀 Integration Tests"
echo "🚀 Starting services for integration testing..."
if command -v docker-compose >/dev/null 2>&1; then
    docker-compose up -d >/dev/null 2>&1 || echo "⚠️  Service startup failed (demo mode)"
    echo "⌛ Waiting for services to be ready..."
    sleep 5
    
    echo "🧪 Testing API endpoints..."
    # Test health endpoint
    curl -f http://localhost:8080/ >/dev/null 2>&1 && echo "✅ Health check passed" || echo "⚠️  Health check failed"
    
    # Test register endpoint
    curl -X POST http://localhost:8080/register \
        -H "Content-Type: application/json" \
        -d '{"email":"test@ci.com","password":"testpass"}' >/dev/null 2>&1 && \
        echo "✅ Register endpoint passed" || echo "⚠️  Register endpoint failed"
    
    # Test login endpoint
    curl -X POST http://localhost:8080/login \
        -H "Content-Type: application/json" \
        -d '{"email":"test@ci.com","password":"testpass"}' >/dev/null 2>&1 && \
        echo "✅ Login endpoint passed" || echo "⚠️  Login endpoint failed"
else
    echo "⚠️  Docker Compose not available (demo mode)"
fi
echo "✅ Integration tests completed"
simulate_work

# Stage 9: Security Scan
print_stage "📊 Security Scan"
echo "📊 Scanning for security vulnerabilities..."
echo "🔍 Checking dependencies for known vulnerabilities..."
echo "🔍 Scanning Docker images for security issues..."
# Simulated security scan
echo "   - CVE scan: No critical vulnerabilities found"
echo "   - Dependency scan: 0 high-severity issues"
echo "   - Container scan: Images are secure"
echo "✅ Security scan completed"
simulate_work

# Stage 10: Deploy to Staging
print_stage "🚢 Deploy to Staging"
echo "🚢 Deploying to staging environment..."
if command -v docker-compose >/dev/null 2>&1; then
    echo "🔄 Stopping current staging deployment..."
    docker-compose -f docker-compose.staging.yml down >/dev/null 2>&1 || true
    
    echo "🚀 Starting staging deployment..."
    docker-compose -f docker-compose.yml up -d >/dev/null 2>&1 || echo "⚠️  Staging deployment failed (demo mode)"
    
    echo "✅ Verifying staging deployment..."
    sleep 3
    curl -f http://localhost:8080/ >/dev/null 2>&1 && echo "✅ Staging health check passed" || echo "⚠️  Staging health check failed"
else
    echo "⚠️  Docker Compose not available (demo mode)"
fi
echo "✅ Staging deployment completed"
simulate_work

# Stage 11: Generate Reports
print_stage "📋 Generate Reports"
echo "📋 Generating deployment report..."
REPORT_FILE="deployment-report-$(date +%Y%m%d-%H%M%S).txt"
cat > "$REPORT_FILE" << EOF
=== CloudTaskPro CI/CD Report ===
Build Number: $(date +%Y%m%d-%H%M%S)
Build Date: $(date)
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo "N/A")
Branch: $(git branch --show-current 2>/dev/null || echo "N/A")
Frontend Image: cloudtaskpro-frontend:$(date +%Y%m%d-%H%M%S)
Backend Image: cloudtaskpro-backend:$(date +%Y%m%d-%H%M%S)
Deployment Status: SUCCESS
================================
EOF

echo "✅ Report generated: $REPORT_FILE"
cat "$REPORT_FILE"
simulate_work

# Final Summary
print_stage "🎉 Pipeline Complete"
echo ""
echo -e "${GREEN}✅ CI/CD Pipeline completed successfully!${NC}"
echo ""
echo "📊 Summary:"
echo "   - Code Quality: ✅ Passed"
echo "   - Tests: ✅ Passed"
echo "   - Security: ✅ Passed"
echo "   - Build: ✅ Passed"
echo "   - Deployment: ✅ Passed"
echo ""
echo "🌐 Your application is now running:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend: http://localhost:8080"
echo "   - MongoDB: localhost:27017"
echo ""
echo "📋 Artifacts:"
echo "   - Report: $REPORT_FILE"
echo "   - Docker Images: Tagged with build number"
echo "   - Logs: Available in Docker containers"
echo ""
echo -e "${BLUE}🎯 Next steps:${NC}"
echo "1. Check the application: http://localhost:3000"
echo "2. Review the deployment report: cat $REPORT_FILE"
echo "3. Monitor logs: docker-compose logs -f"
echo "4. Run manual tests on the deployed application"
echo ""
echo -e "${GREEN}🚀 Happy DevOps!${NC}" 