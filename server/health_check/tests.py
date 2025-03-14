from django.test import TestCase
from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status
from .models import Book, ReadingProgress
import json

class BookModelTests(TestCase):
    @classmethod
    def setUpTestData(cls):
        # Create a test user
        cls.test_user = User.objects.create_user(
            username='testuser',
            password='password123'
        )
        
        # Create a test book
        cls.test_book = Book.objects.create(
            title='Test Book',
            author='Test Author',
            genre='Fiction',
            pages=200,
            description='Test book description',
            is_currently_reading=True,
            user=cls.test_user
        )
        
        # Create reading progress for the book
        cls.test_progress = ReadingProgress.objects.create(
            book=cls.test_book,
            current_page=50
        )
    
    def test_book_creation(self):
        """Test that a book is created correctly"""
        self.assertEqual(self.test_book.title, 'Test Book')
        self.assertEqual(self.test_book.author, 'Test Author')
        self.assertEqual(self.test_book.user, self.test_user)
        
    def test_reading_progress_calculation(self):
        """Test that reading progress percentage is calculated correctly"""
        self.assertEqual(self.test_progress.current_page, 50)
        self.assertEqual(self.test_progress.percentage_complete, 25)  # 50/200 * 100 = 25%
        
class BookAPITests(TestCase):
    @classmethod
    def setUpTestData(cls):
        # Create test users
        cls.user1 = User.objects.create_user(
            username='user1',
            password='password123'
        )
        
        cls.user2 = User.objects.create_user(
            username='user2',
            password='password456'
        )
        
        # Create test books for user1
        cls.book1 = Book.objects.create(
            title='User 1 Book 1',
            author='Author 1',
            genre='Fiction',
            pages=200,
            is_currently_reading=True,
            user=cls.user1
        )
        
        cls.book2 = Book.objects.create(
            title='User 1 Book 2',
            author='Author 2',
            genre='Non-Fiction',
            pages=300,
            is_currently_reading=False,
            user=cls.user1
        )
        
        # Create test book for user2
        cls.book3 = Book.objects.create(
            title='User 2 Book',
            author='Author 3',
            genre='Science Fiction',
            pages=250,
            is_currently_reading=True,
            user=cls.user2
        )
    
    def setUp(self):
        self.client = APIClient()
    
    def test_get_books_authenticated(self):
        """Test that an authenticated user can get their books"""
        self.client.force_authenticate(user=self.user1)
        response = self.client.get(reverse('book-list'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 2)  # User1 has 2 books
        
    def test_get_books_unauthenticated(self):
        """Test that an unauthenticated user cannot get books"""
        response = self.client.get(reverse('book-list'))
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
    
    def test_user_can_only_see_own_books(self):
        """Test that a user can only see their own books"""
        self.client.force_authenticate(user=self.user1)
        response = self.client.get(reverse('book-list'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
        # Check that only user1's books are returned
        book_ids = [book['id'] for book in response.data['results']]
        self.assertIn(self.book1.id, book_ids)
        self.assertIn(self.book2.id, book_ids)
        self.assertNotIn(self.book3.id, book_ids)
    
    def test_create_book(self):
        """Test that a user can create a book"""
        self.client.force_authenticate(user=self.user1)
        book_data = {
            'title': 'New Book',
            'author': 'New Author',
            'genre': 'Mystery',
            'pages': 250,
            'is_currently_reading': True
        }
        response = self.client.post(
            reverse('book-list'),
            data=json.dumps(book_data),
            content_type='application/json'
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['title'], 'New Book')
        
        # Check that the book is created in the database
        self.assertTrue(Book.objects.filter(title='New Book', user=self.user1).exists())
    
    def test_filter_currently_reading(self):
        """Test filtering books by currently reading status"""
        self.client.force_authenticate(user=self.user1)
        response = self.client.get(reverse('currently-reading'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        
        # Only book1 is currently being read by user1
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['id'], self.book1.id)
    
    def test_toggle_reading_status(self):
        """Test toggling the reading status of a book"""
        self.client.force_authenticate(user=self.user1)
        
        # Book1 is currently being read, toggle it to not reading
        response = self.client.patch(reverse('toggle-reading', args=[self.book1.id]))
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['is_currently_reading'], False)
        
        # Refresh from database and check status
        self.book1.refresh_from_db()
        self.assertEqual(self.book1.is_currently_reading, False)