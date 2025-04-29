import pytest
from app import app as flask_app, db, User  # import app, database, and model correctly

@pytest.fixture
def app():
    # Setup the application for testing
    flask_app.config['TESTING'] = True
    flask_app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with flask_app.app_context():
        db.create_all()
    yield flask_app
    with flask_app.app_context():
        db.session.remove()
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture(autouse=True)
def clear_database(app):
    with app.app_context():
        db.session.remove()
        db.drop_all()
        db.create_all()

def test_register(client):
    response = client.post('/register', json={
        'username': 'testuser',
        'password': 'testpassword'
    })
    assert response.status_code == 201
    assert response.get_json()['message'] == 'User registered successfully'
    print("Test register function successfully")

def test_login_success(client):
    # First, register the user
    client.post('/register', json={
        'username': 'testuser2',
        'password': 'testpassword'
    })
    # Then, try to login
    response = client.post('/login', json={
        'username': 'testuser2',
        'password': 'testpassword'
    })
    assert response.status_code == 200
    assert response.get_json()['message'] == 'Login successful'
    print("Test login function successfully")

def test_login_fail(client):
    response = client.post('/login', json={
        'username': 'wronguser',
        'password': 'wrongpassword'
    })
    assert response.status_code == 401
    assert response.get_json()['error'] == 'Invalid credentials'
    print("Test login function failed successfully")

def test_register_existing_user(client):
    # First registration
    client.post('/register', json={
        'username': 'testuser',
        'password': 'password123'
    })

    # Attempt to register again with the same username
    response = client.post('/register', json={
        'username': 'testuser',
        'password': 'password123'
    })

    assert response.status_code == 409
    assert response.json['error'] == 'Username already exists'
    print("Test login function failed successfully")

def test_welcome(client):
    response = client.get('/welcome')
    assert response.status_code == 200
    assert b'Welcome to the SIT753 HD project! This is a simple Flask application with user registration and login functionality.' in response.data