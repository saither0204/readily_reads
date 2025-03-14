from rest_framework import viewsets, status, filters, generics
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from .models import Book, ReadingProgress
from .serializers import BookSerializer, ReadingProgressSerializer, GenreSerializer
from .permissions import IsBookOwner

class BookViewSet(viewsets.ModelViewSet):
    """
    ViewSet for Book CRUD operations
    """
    serializer_class = BookSerializer
    permission_classes = [IsAuthenticated, IsBookOwner]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['title', 'author', 'genre', 'description']
    ordering_fields = ['title', 'author', 'created_at', 'updated_at']
    ordering = ['-created_at']
    
    def get_queryset(self):
        """
        This view returns books belonging to the current user,
        with optional filtering.
        """
        user = self.request.user
        queryset = Book.objects.filter(user=user)
        
        # Filter by genre if provided
        genre = self.request.query_params.get('genre', None)
        if genre and genre != 'All Genres':
            queryset = queryset.filter(genre=genre)
            
        # Filter by reading status if provided
        is_reading = self.request.query_params.get('is_currently_reading', None)
        if is_reading is not None:
            is_reading = is_reading.lower() == 'true'
            queryset = queryset.filter(is_currently_reading=is_reading)
            
        # Filter by search query if provided
        query = self.request.query_params.get('query', None)
        if query:
            queryset = queryset.filter(
                Q(title__icontains=query) |
                Q(author__icontains=query) |
                Q(description__icontains=query)
            )
            
        return queryset
    
    def perform_create(self, serializer):
        """Save the book with the current user"""
        serializer.save(user=self.request.user)
        
    @action(detail=True, methods=['patch'])
    def toggle_reading(self, request, pk=None):
        """Toggle the currently reading status of a book"""
        book = self.get_object()
        book.is_currently_reading = not book.is_currently_reading
        book.save()
        return Response({
            'message': 'Reading status updated successfully',
            'is_currently_reading': book.is_currently_reading
        })
    
    @action(detail=False, methods=['get'])
    def currently_reading(self, request):
        """Get all books that are currently being read"""
        books = self.get_queryset().filter(is_currently_reading=True)
        serializer = self.get_serializer(books, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def genres(self, request):
        """Get a list of all genres used by the current user"""
        user = request.user
        genres = Book.objects.filter(user=user).values_list('genre', flat=True).distinct()
        # Add 'All Genres' as the first option
        genre_list = ['All Genres'] + list(genres)
        serializer = GenreSerializer({'genres': genre_list})
        return Response(serializer.data)
        
class ReadingProgressViewSet(viewsets.ModelViewSet):
    """
    ViewSet for updating reading progress
    """
    serializer_class = ReadingProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return ReadingProgress.objects.filter(book__user=self.request.user)
        
    def perform_create(self, serializer):
        # Get the book_id from the URL
        book_id = self.kwargs.get('book_pk')
        book = Book.objects.get(id=book_id, user=self.request.user)
        serializer.save(book=book)