# Readily Reads API

This is the Django REST Framework backend for the Readily Reads book tracking application. It provides user authentication, book management, and reading progress tracking.

## Features

- **User Authentication**: Secure registration and login with JWT tokens
- **Book Management**: Add, list, update, and delete books
- **Reading Status**: Track which books you're currently reading
- **Reading Progress**: Track your progress through each book
- **Admin Interface**: Built-in admin panel for easy data management
- **API Documentation**: Swagger/OpenAPI documentation

## Tech Stack

- **Django**: Web framework
- **Django REST Framework**: API toolkit
- **PostgreSQL**: Database (configurable)
- **JWT Authentication**: Secure token-based authentication
- **Swagger/ReDoc**: API documentation

## Directory Structure

The project directory structure is organized as follows:

```plaintext
readily_reads_api/                  # Root project directory
├── manage.py                       # Django management script
├── requirements.txt                # Project dependencies
├── Dockerfile                      # Docker configuration
├── .env.example                    # Environment variables template
├── README.md                       # Project documentation
│
├── readily_reads/                  # Main project package
│   ├── __init__.py                 # Package marker
│   ├── asgi.py                     # ASGI configuration 
│   ├── settings.py                 # Project settings
│   ├── urls.py                     # Main URL configuration
│   └── wsgi.py                     # WSGI configuration
│
├── authentication/                 # Authentication app
│   ├── __init__.py                 # Package marker
│   ├── admin.py                    # Admin configuration
│   ├── apps.py                     # App configuration
│   ├── migrations/                 # Database migrations
│   │   └── __init__.py
│   ├── models.py                   # UserProfile model
│   ├── serializers.py              # User serializers
│   ├── signals.py                  # User signals
│   ├── tests.py                    # Authentication tests
│   ├── urls.py                     # Authentication URLs
│   └── views.py                    # Authentication views
│
├── books/                          # Books app
│   ├── __init__.py                 # Package marker  
│   ├── admin.py                    # Admin configuration
│   ├── apps.py                     # App configuration
│   ├── migrations/                 # Database migrations
│   │   └── __init__.py
│   ├── models.py                   # Book and ReadingProgress models
│   ├── permissions.py              # Custom permissions
│   ├── serializers.py              # Book serializers
│   ├── tests.py                    # Book tests
│   ├── urls.py                     # Book URLs
│   └── views.py                    # Book views
│
├── health_check/                   # Health check app
│   ├── __init__.py                 # Package marker
│   ├── urls.py                     # Health check URLs
│   └── views.py                    # Health check view
│
├── staticfiles/                    # Collected static files (created by collectstatic)
└── media/                          # User uploaded files (created at runtime)
```

## Setup

### Prerequisites

- Python 3.9+
- pip (Python package manager)
- Virtual environment (recommended)

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd readily-reads-api
   ```

2. Create and activate a virtual environment:

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Set up environment variables:

   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

5. Run migrations:

   ```bash
   python manage.py migrate
   ```

6. Create a superuser for the admin interface:

   ```bash
   python manage.py createsuperuser
   ```

7. Start the development server:

   ```bash
   python manage.py runserver
   ```

The API will be available at <http://localhost:8000/> and the admin interface at <http://localhost:8000/admin/>.

## API Documentation

Interactive API documentation is available at:

- **Swagger UI**: `/api/docs/`
- **ReDoc**: `/api/redoc/`

### Main Endpoints

#### Authentication

- **Register**: `POST /api/auth/register/`
- **Login**: `POST /api/auth/login/`
- **Refresh Token**: `POST /api/auth/token/refresh/`
- **User Profile**: `GET /api/auth/me/`

#### Books

- **List Books**: `GET /api/books/`
- **Create Book**: `POST /api/books/`
- **Get Book**: `GET /api/books/{id}/`
- **Update Book**: `PUT/PATCH /api/books/{id}/`
- **Delete Book**: `DELETE /api/books/{id}/`
- **Currently Reading**: `GET /api/books/currently-reading/`
- **Genres**: `GET /api/books/genres/`
- **Toggle Reading Status**: `PATCH /api/books/{id}/toggle-reading/`

#### Reading Progress

- **Get/Update Progress**: `GET/PUT/PATCH /api/books/{book_id}/progress/`

## Testing

Run the automated tests with:

```bash
python manage.py test
```

## Deployment

### Using Docker

1. Build the Docker image:

   ```bash
   docker build -t readily-reads-api .
   ```

2. Run the container:

   ```bash
   docker run -p 8000:8000 -e SECRET_KEY=your-secret-key -e DEBUG=False readily-reads-api
   ```

## Integration with Mobile App

To use this API with the Readily Reads Flutter mobile app, you'll need to:

1. Update the Flutter app's service classes to make HTTP requests to this API
2. Implement JWT token storage and management in the mobile app
3. Update the UI to handle loading states and errors

## License

This project is licensed under the MIT License - see the LICENSE file for details.
