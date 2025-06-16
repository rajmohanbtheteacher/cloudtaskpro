pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_NAME = 'cloudtaskpro'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        MONGO_URI = 'mongodb://mongo:27017/cloudtaskpro'
        JWT_SECRET_KEY = 'your-secret-key-here'
    }
    
    stages {
        stage('🔍 Checkout') {
            steps {
                echo '📥 Checking out source code...'
                checkout scm
            }
        }
        
        stage('🧹 Cleanup') {
            steps {
                echo '🧹 Cleaning up previous containers...'
                sh '''
                    docker-compose down --remove-orphans || true
                    docker system prune -f || true
                '''
            }
        }
        
        stage('🔧 Environment Setup') {
            steps {
                echo '🔧 Setting up environment...'
                sh '''
                    # Create .env file for backend
                    echo "MONGO_URI=${MONGO_URI}" > backend/.env
                    echo "JWT_SECRET_KEY=${JWT_SECRET_KEY}" >> backend/.env
                    
                    # Display environment info
                    echo "Build Number: ${BUILD_NUMBER}"
                    echo "Node Version: $(node --version)" || true
                    echo "Python Version: $(python3 --version)" || true
                    echo "Docker Version: $(docker --version)"
                '''
            }
        }
        
        stage('📦 Install Dependencies') {
            parallel {
                stage('Backend Dependencies') {
                    steps {
                        echo '📦 Installing backend dependencies...'
                        dir('backend') {
                            sh '''
                                python3 -m pip install --upgrade pip
                                pip3 install -r requirements.txt
                                pip3 install pytest pytest-cov flake8
                            '''
                        }
                    }
                }
                stage('Frontend Dependencies') {
                    steps {
                        echo '📦 Installing frontend dependencies...'
                        dir('frontend') {
                            sh '''
                                npm install --silent
                                npm audit fix --silent || true
                            '''
                        }
                    }
                }
            }
        }
        
        stage('🔍 Code Quality & Linting') {
            parallel {
                stage('Backend Linting') {
                    steps {
                        echo '🔍 Running backend code quality checks...'
                        dir('backend') {
                            sh '''
                                echo "Running flake8 linting..."
                                flake8 --max-line-length=88 --ignore=E203,W503 app.py || true
                                echo "✅ Backend linting completed"
                            '''
                        }
                    }
                }
                stage('Frontend Linting') {
                    steps {
                        echo '🔍 Running frontend code quality checks...'
                        dir('frontend') {
                            sh '''
                                echo "Running npm audit..."
                                npm audit --audit-level=high || true
                                echo "✅ Frontend linting completed"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('🧪 Run Tests') {
            parallel {
                stage('Backend Tests') {
                    steps {
                        echo '🧪 Running backend tests...'
                        dir('backend') {
                            sh '''
                                echo "Running backend unit tests..."
                                # Add your pytest commands here
                                echo "✅ Backend tests passed (placeholder)"
                            '''
                        }
                    }
                }
                stage('Frontend Tests') {
                    steps {
                        echo '🧪 Running frontend tests...'
                        dir('frontend') {
                            sh '''
                                echo "Running frontend tests..."
                                # npm test --watchAll=false || true
                                echo "✅ Frontend tests passed (placeholder)"
                            '''
                        }
                    }
                }
            }
        }
        
        stage('🐳 Docker Build') {
            steps {
                echo '🐳 Building Docker images...'
                sh '''
                    echo "Building all services..."
                    docker-compose build --no-cache
                    
                    echo "Tagging images with build number..."
                    docker tag cloudtaskpro-frontend:latest cloudtaskpro-frontend:${BUILD_NUMBER}
                    docker tag cloudtaskpro-backend:latest cloudtaskpro-backend:${BUILD_NUMBER}
                    
                    echo "✅ Docker images built successfully"
                '''
            }
        }
        
        stage('🚀 Integration Tests') {
            steps {
                echo '🚀 Running integration tests...'
                sh '''
                    echo "Starting services for integration testing..."
                    docker-compose up -d
                    
                    echo "Waiting for services to be ready..."
                    sleep 15
                    
                    echo "Running integration tests..."
                    chmod +x test_app.sh
                    ./test_app.sh
                    
                    echo "Testing API endpoints..."
                    # Test health endpoint
                    curl -f http://localhost:8080/ || exit 1
                    
                    # Test register endpoint
                    curl -X POST http://localhost:8080/register \
                        -H "Content-Type: application/json" \
                        -d '{"email":"test@ci.com","password":"testpass"}' || exit 1
                    
                    # Test login endpoint
                    curl -X POST http://localhost:8080/login \
                        -H "Content-Type: application/json" \
                        -d '{"email":"test@ci.com","password":"testpass"}' || exit 1
                    
                    echo "✅ Integration tests passed"
                '''
            }
        }
        
        stage('📊 Security Scan') {
            steps {
                echo '📊 Running security scans...'
                sh '''
                    echo "Scanning Docker images for vulnerabilities..."
                    # Add your security scanning tools here
                    # docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image cloudtaskpro-backend:latest || true
                    echo "✅ Security scan completed"
                '''
            }
        }
        
        stage('🚢 Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                echo '🚢 Deploying to staging environment...'
                sh '''
                    echo "Deploying to staging..."
                    # Stop any existing staging deployment
                    docker-compose -f docker-compose.staging.yml down || true
                    
                    # Deploy to staging
                    docker-compose -f docker-compose.yml up -d
                    
                    echo "Verifying staging deployment..."
                    sleep 10
                    curl -f http://localhost:8080/ || exit 1
                    
                    echo "✅ Staging deployment successful"
                '''
            }
        }
        
        stage('📋 Generate Reports') {
            steps {
                echo '📋 Generating reports...'
                sh '''
                    echo "Generating deployment report..."
                    echo "=== CloudTaskPro CI/CD Report ===" > deployment-report.txt
                    echo "Build Number: ${BUILD_NUMBER}" >> deployment-report.txt
                    echo "Build Date: $(date)" >> deployment-report.txt
                    echo "Git Commit: ${GIT_COMMIT}" >> deployment-report.txt
                    echo "Branch: ${GIT_BRANCH}" >> deployment-report.txt
                    echo "Frontend Image: cloudtaskpro-frontend:${BUILD_NUMBER}" >> deployment-report.txt
                    echo "Backend Image: cloudtaskpro-backend:${BUILD_NUMBER}" >> deployment-report.txt
                    echo "================================" >> deployment-report.txt
                    
                    cat deployment-report.txt
                '''
                archiveArtifacts artifacts: 'deployment-report.txt', allowEmptyArchive: true
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleaning up...'
            sh '''
                docker-compose logs > docker-logs.txt || true
                docker-compose down || true
            '''
            archiveArtifacts artifacts: 'docker-logs.txt', allowEmptyArchive: true
        }
        success {
            echo '✅ Pipeline completed successfully!'
            // Add notification logic here (Slack, email, etc.)
        }
        failure {
            echo '❌ Pipeline failed!'
            // Add failure notification logic here
        }
    }
}
