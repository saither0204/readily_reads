from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BookViewSet, ReadingProgressViewSet

# Create a router and register our viewsets
router = DefaultRouter()
router.register(r'', BookViewSet, basename='book')

urlpatterns = [
    # Main book CRUD routes
    path('', include(router.urls)),
    
    # Currently reading books
    path('currently-reading/', BookViewSet.as_view({'get': 'currently_reading'}), name='currently-reading'),
    
    # Get all genres
    path('genres/', BookViewSet.as_view({'get': 'genres'}), name='book-genres'),
    
    # Toggle reading status
    path('<int:pk>/toggle-reading/', BookViewSet.as_view({'patch': 'toggle_reading'}), name='toggle-reading'),
    
    # Reading progress routes (nested under a book)
    path('<int:book_pk>/progress/', ReadingProgressViewSet.as_view({'get': 'retrieve', 'put': 'update', 'patch': 'partial_update'}), name='reading-progress'),
]