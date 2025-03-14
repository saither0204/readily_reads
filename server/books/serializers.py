from rest_framework import serializers
from .models import Book, ReadingProgress

class ReadingProgressSerializer(serializers.ModelSerializer):
    """
    Serializer for reading progress
    """
    percentage_complete = serializers.IntegerField(read_only=True)
    
    class Meta:
        model = ReadingProgress
        fields = ['current_page', 'start_date', 'target_end_date', 'notes', 'percentage_complete']
        
class BookSerializer(serializers.ModelSerializer):
    """
    Serializer for book model
    """
    reading_progress = ReadingProgressSerializer(required=False)
    
    class Meta:
        model = Book
        fields = [
            'id', 'title', 'author', 'genre', 'pages', 'description', 
            'publication_date', 'is_currently_reading', 'created_at', 
            'updated_at', 'reading_progress'
        ]
        read_only_fields = ['id', 'created_at', 'updated_at']
    
    def create(self, validated_data):
        # Extract nested reading_progress data if it exists
        reading_progress_data = validated_data.pop('reading_progress', None)
        
        # Create the book
        book = Book.objects.create(**validated_data)
        
        # Create reading progress if provided
        if reading_progress_data:
            ReadingProgress.objects.create(book=book, **reading_progress_data)
        else:
            # Create default reading progress
            ReadingProgress.objects.create(book=book)
            
        return book
    
    def update(self, instance, validated_data):
        # Extract nested reading_progress data if it exists
        reading_progress_data = validated_data.pop('reading_progress', None)
        
        # Update book fields
        for field, value in validated_data.items():
            setattr(instance, field, value)
        instance.save()
        
        # Update reading progress if provided
        if reading_progress_data and hasattr(instance, 'reading_progress'):
            progress = instance.reading_progress
            for field, value in reading_progress_data.items():
                setattr(progress, field, value)
            progress.save()
        
        return instance
        
class GenreSerializer(serializers.Serializer):
    """
    Serializer for genre list
    """
    genres = serializers.ListField(child=serializers.CharField())