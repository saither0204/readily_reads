from django.test import TestCase
from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from .models import UserProfile
import json

class AuthenticationTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        
        # Create a test user
        self.test_user = User.objects.create_user(
            username='testuser',
            password='password123'
        )
    
    def test_user_registration(self):
        """Test user registration"""
        url = reverse('auth_register')
        data = {
            'username': 'newuser',
            'password': 'newpassword123',
            'password2': 'newpassword123'
        }
        response = self.client.post(
            url, 
            data=json.dumps(data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['user']['username'], 'newuser')
        self.assertTrue('token' in response.data)
        
        # Check that a profile was created
        self.assertTrue(UserProfile.objects.filter(user__username='newuser').exists())
    
    def test_user_registration_missing_fields(self):
        """Test user registration with missing fields"""
        url = reverse('auth_register')
        data = {
            'username': 'newuser',
            # Missing password fields
        }
        response = self.client.post(
            url, 
            data=json.dumps(data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
    
    def test_user_registration_password_mismatch(self):
        """Test user registration with mismatched passwords"""
        url = reverse('auth_register')
        data = {
            'username': 'newuser',
            'password': 'password123',
            'password2': 'differentpassword'
        }
        response = self.client.post(
            url, 
            data=json.dumps(data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
    
    def test_user_login(self):
        """Test user login"""
        url = reverse('token_obtain_pair')
        data = {
            'username': 'testuser',
            'password': 'password123'
        }
        response = self.client.post(
            url, 
            data=json.dumps(data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue('access' in response.data)
        self.assertTrue('refresh' in response.data)
    
    def test_user_login_invalid_credentials(self):
        """Test user login with invalid credentials"""
        url = reverse('token_obtain_pair')
        data = {
            'username': 'testuser',
            'password': 'wrongpassword'
        }
        response = self.client.post(
            url, 
            data=json.dumps(data),
            content_type='application/json'
        )
        
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_get_user_profile(self):
        """Test getting user profile"""
        url = reverse('user_profile')
        
        # Authenticate the client
        self.client.force_authenticate(user=self.test_user)
        
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['username'], 'testuser')
    
    def test_token_refresh(self):
        """Test refreshing JWT token"""
        # First, get a token
        login_url = reverse('token_obtain_pair')
        login_data = {
            'username': 'testuser',
            'password': 'password123'
        }
        login_response = self.client.post(
            login_url, 
            data=json.dumps(login_data),
            content_type='application/json'
        )
        
        refresh_token = login_response.data['refresh']
        
        # Now try to refresh the token
        refresh_url = reverse('token_refresh')
        refresh_data = {
            'refresh': refresh_token
        }
        refresh_response = self.client.post(
            refresh_url, 
            data=json.dumps(refresh_data),
            content_type='application/json'
        )
        
        self.assertEqual(refresh_response.status_code, status.HTTP_200_OK)
        self.assertTrue('access' in refresh_response.data)