import pytest
import json
from app import app
from unittest.mock import patch, MagicMock

@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    """Test the health check endpoint."""
    response = client.get('/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert data['service'] == 'CloudTaskPro Backend'

@patch('app.users')
def test_register_new_user(mock_users, client):
    """Test user registration with new user."""
    # Mock that user doesn't exist
    mock_users.find_one.return_value = None
    mock_users.insert_one.return_value = True
    
    response = client.post('/register', 
                          json={'email': 'test@example.com', 'password': 'testpass'})
    
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['msg'] == 'User registered'

@patch('app.users')
def test_register_existing_user(mock_users, client):
    """Test user registration with existing user."""
    # Mock that user already exists
    mock_users.find_one.return_value = {'email': 'test@example.com'}
    
    response = client.post('/register', 
                          json={'email': 'test@example.com', 'password': 'testpass'})
    
    assert response.status_code == 409
    data = json.loads(response.data)
    assert data['msg'] == 'User already exists'

@patch('app.users')
@patch('app.create_access_token')
def test_login_valid_credentials(mock_create_token, mock_users, client):
    """Test login with valid credentials."""
    # Mock user exists and token creation
    mock_users.find_one.return_value = {'email': 'test@example.com', 'password': 'testpass'}
    mock_create_token.return_value = 'fake-jwt-token'
    
    response = client.post('/login', 
                          json={'email': 'test@example.com', 'password': 'testpass'})
    
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'token' in data

@patch('app.users')
def test_login_invalid_credentials(mock_users, client):
    """Test login with invalid credentials."""
    # Mock that user doesn't exist or wrong password
    mock_users.find_one.return_value = None
    
    response = client.post('/login', 
                          json={'email': 'test@example.com', 'password': 'wrongpass'})
    
    assert response.status_code == 401
    data = json.loads(response.data)
    assert data['msg'] == 'Invalid credentials'

def test_tasks_endpoint_requires_auth(client):
    """Test that tasks endpoint requires authentication."""
    response = client.get('/tasks')
    assert response.status_code == 401  # Unauthorized

if __name__ == '__main__':
    pytest.main(['-v', __file__]) 