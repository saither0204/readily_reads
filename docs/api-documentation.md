# API Documentation for [Your Mobile App Name]

This document outlines the API endpoints or services used by [Your Mobile App Name]. Use this as a reference for understanding how the mobile app interacts with backend services.

## API Overview

[Provide an overview of your API or backend services. Indicate whether you're using a custom API, Firebase, or other services]

## Base URL

- **Development**: `http://localhost:8000/api` (or your configured endpoint)
- **Production**: `[Your production API URL]`
- **Staging**: `[Your staging API URL]` (if applicable)

## Authentication

Most endpoints require authentication. Our app uses [Token-based/OAuth/Firebase/etc.] authentication.

### Authentication Headers

Include the authentication token in your requests:

```plaintext
Authorization: Bearer [your_token]
```

### Authentication Endpoints

#### Login

- **URL**: `/auth/login`
- **Method**: `POST`
- **Request Body**:

  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "token": "auth-token-here",
      "user": {
        "id": "user-id",
        "name": "User Name",
        "email": "user@example.com",
        "role": "user"
      }
    }
    ```

- **Error Response**:
  - **Code**: 401 Unauthorized
  - **Content**:

    ```json
    {
      "message": "Invalid credentials"
    }
    ```

#### Register

- **URL**: `/auth/register`
- **Method**: `POST`
- **Request Body**:

  ```json
  {
    "name": "User Name",
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **Success Response**:
  - **Code**: 201 Created
  - **Content**:

    ```json
    {
      "message": "User registered successfully",
      "user": {
        "id": "user-id",
        "name": "User Name",
        "email": "user@example.com",
        "role": "user"
      }
    }
    ```

- **Error Response**:
  - **Code**: 400 Bad Request
  - **Content**:

    ```json
    {
      "message": "Email already in use"
    }
    ```

#### Get User Profile

- **URL**: `/auth/me`
- **Method**: `GET`
- **Authentication Required**: Yes
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "user": {
        "id": "user-id",
        "name": "User Name",
        "email": "user@example.com",
        "role": "user"
      }
    }
    ```

## [Resource Name] Endpoints

### Get All [Resources]

- **URL**: `/[resources]`
- **Method**: `GET`
- **Authentication Required**: Yes
- **Query Parameters**:
  - `page`: Page number (default: 1)
  - `limit`: Items per page (default: 10)
  - `sort`: Field to sort by
  - `order`: Sort order ('asc' or 'desc')
  - `[Additional parameters]`
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "data": [
        {
          "id": "resource-id-1",
          "name": "Resource 1",
          "description": "Description for Resource 1",
          "createdAt": "2023-01-01T00:00:00.000Z",
          "updatedAt": "2023-01-01T00:00:00.000Z"
        },
        {
          "id": "resource-id-2",
          "name": "Resource 2",
          "description": "Description for Resource 2",
          "createdAt": "2023-01-02T00:00:00.000Z",
          "updatedAt": "2023-01-02T00:00:00.000Z"
        }
      ],
      "pagination": {
        "totalItems": 25,
        "totalPages": 3,
        "currentPage": 1,
        "limit": 10
      }
    }
    ```

### Get Single [Resource]

- **URL**: `/[resources]/:id`
- **Method**: `GET`
- **Authentication Required**: Yes
- **URL Parameters**:
  - `id`: ID of the resource
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "id": "resource-id",
      "name": "Resource Name",
      "description": "Resource Description",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
    ```

- **Error Response**:
  - **Code**: 404 Not Found
  - **Content**:

    ```json
    {
      "message": "Resource not found"
    }
    ```

### Create [Resource]

- **URL**: `/[resources]`
- **Method**: `POST`
- **Authentication Required**: Yes
- **Request Body**:

  ```json
  {
    "name": "New Resource",
    "description": "Description for New Resource",
    "[Additional fields]": "[values]"
  }
  ```

- **Success Response**:
  - **Code**: 201 Created
  - **Content**:

    ```json
    {
      "id": "new-resource-id",
      "name": "New Resource",
      "description": "Description for New Resource",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-01T00:00:00.000Z"
    }
    ```

- **Error Response**:
  - **Code**: 400 Bad Request
  - **Content**:

    ```json
    {
      "message": "Validation error",
      "errors": [
        {
          "field": "name",
          "message": "Name is required"
        }
      ]
    }
    ```

### Update [Resource]

- **URL**: `/[resources]/:id`
- **Method**: `PUT` or `PATCH`
- **Authentication Required**: Yes
- **URL Parameters**:
  - `id`: ID of the resource
- **Request Body**:

  ```json
  {
    "name": "Updated Resource Name",
    "description": "Updated Description",
    "[Additional fields]": "[values]"
  }
  ```

- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "id": "resource-id",
      "name": "Updated Resource Name",
      "description": "Updated Description",
      "createdAt": "2023-01-01T00:00:00.000Z",
      "updatedAt": "2023-01-02T00:00:00.000Z"
    }
    ```

- **Error Response**:
  - **Code**: 404 Not Found
  - **Content**:

    ```json
    {
      "message": "Resource not found"
    }
    ```

### Delete [Resource]

- **URL**: `/[resources]/:id`
- **Method**: `DELETE`
- **Authentication Required**: Yes
- **URL Parameters**:
  - `id`: ID of the resource
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "message": "Resource deleted successfully"
    }
    ```

- **Error Response**:
  - **Code**: 404 Not Found
  - **Content**:

    ```json
    {
      "message": "Resource not found"
    }
    ```

## Mobile-Specific Endpoints

### Device Registration

- **URL**: `/devices/register`
- **Method**: `POST`
- **Authentication Required**: Yes
- **Request Body**:

  ```json
  {
    "deviceToken": "fcm-token-for-push-notifications",
    "deviceType": "android | ios",
    "deviceModel": "Device model information"
  }
  ```

- **Success Response**:
  - **Code**: 201 Created
  - **Content**:

    ```json
    {
      "message": "Device registered successfully",
      "deviceId": "device-id"
    }
    ```

### App Configuration

- **URL**: `/config`
- **Method**: `GET`
- **Authentication Required**: Optional
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:

    ```json
    {
      "latestVersion": "1.0.1",
      "minimumRequiredVersion": "1.0.0",
      "forceUpdate": false,
      "maintenanceMode": false,
      "features": {
        "featureA": true,
        "featureB": false
      }
    }
    ```

## Error Handling

All endpoints follow a consistent error response format:

```json
{
  "message": "Error message",
  "errors": [
    {
      "field": "field_name",
      "message": "Specific error message for this field"
    }
  ],
  "status": 400,
  "timestamp": "2023-01-01T00:00:00.000Z"
}
```

### Common Status Codes

- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully
- **400 Bad Request**: Invalid request (validation errors, etc.)
- **401 Unauthorized**: Authentication required or failed
- **403 Forbidden**: Not authorized to access the resource
- **404 Not Found**: Resource not found
- **422 Unprocessable Entity**: Request understood but could not be processed
- **500 Internal Server Error**: Server error

## Rate Limiting

API calls are limited to [limit] requests per [time period] per device. When the rate limit is exceeded, the API will respond with:

- **Code**: 429 Too Many Requests
- **Content**:

  ```json
  {
    "message": "Rate limit exceeded. Try again after [time]",
    "status": 429,
    "timestamp": "2023-01-01T00:00:00.000Z"
  }
  ```

- **Headers**:
  - `X-RateLimit-Limit`: [requests per time period]
  - `X-RateLimit-Remaining`: [requests remaining]
  - `X-RateLimit-Reset`: [timestamp when the limit resets]

## Data Models

### User

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "role": "string (user, admin)",
  "createdAt": "ISO date string",
  "updatedAt": "ISO date string"
}
```

### [Resource Model]

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "userId": "string (references User)",
  "[Additional fields]": "[types]",
  "createdAt": "ISO date string",
  "updatedAt": "ISO date string"
}
```

## API Versioning

The API is versioned using URL path versioning. The current version is `v1`:

```plaintext
/api/v1/[resources]
```

## Pagination

Collection endpoints support pagination with the following query parameters:

- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)

Pagination metadata is included in the response:

```json
{
  "data": [...],
  "pagination": {
    "totalItems": 25,
    "totalPages": 3,
    "currentPage": 1,
    "limit": 10
  }
}
```

## Working with the API in Dart/Flutter

### Example API Service Class

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String token;
  
  ApiService({required this.baseUrl, this.token = ''});
  
  Future<Map<String, String>> get _headers async {
    return {
      'Content-Type': 'application/json',
      'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
    };
  }
  
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _headers,
    );
    
    return _handleResponse(response);
  }
  
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _headers,
      body: jsonEncode(data),
    );
    
    return _handleResponse(response);
  }
  
  // Add put, delete methods similarly
  
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
```

### Using the API in Dart/Flutter

```dart
// Example usage in a Flutter app
final apiService = ApiService(
  baseUrl: 'https://api.yourdomain.com',
  token: 'user-auth-token',
);

// Get user profile
Future<void> getUserProfile() async {
  try {
    final userData = await apiService.get('auth/me');
    print('User data: $userData');
  } catch (e) {
    print('Error getting user profile: $e');
  }
}

// Create a resource
Future<void> createResource(Map<String, dynamic> resourceData) async {
  try {
    final newResource = await apiService.post('resources', resourceData);
    print('Created resource: $newResource');
  } catch (e) {
    print('Error creating resource: $e');
  }
}
```
