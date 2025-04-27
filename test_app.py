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

def test_login_fail(client):
    response = client.post('/login', json={
        'username': 'wronguser',
        'password': 'wrongpassword'
    })
    assert response.status_code == 401
    assert response.get_json()['error'] == 'Invalid credentials'
