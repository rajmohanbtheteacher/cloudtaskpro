#!/bin/bash

echo "🔧 Starting CloudTaskPro with Docker Compose..."
docker-compose up --build -d

echo "⏳ Waiting for containers to initialize..."
sleep 10

echo "🚀 Testing Flask backend health..."
curl -s http://localhost:8080/health || echo "❌ Backend health check failed"

echo "✅ App should be running:"
echo "➡ Frontend: http://localhost:3000"
echo "➡ Backend:  http://localhost:8080"
echo "➡ MongoDB:  localhost:27017"

echo "📋 Use these API endpoints to test manually:"
echo "POST /register → http://localhost:8080/register"
echo "POST /login    → http://localhost:8080/login"
echo "GET  /tasks    → http://localhost:8080/tasks (requires JWT)"
