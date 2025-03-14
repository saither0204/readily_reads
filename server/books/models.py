from django.db import models
from django.contrib.auth.models import User
from django.utils.translation import gettext_lazy as _

class Book(models.Model):
    """
    Model representing a book in a user's library
    """
    title = models.CharField(_('Title'), max_length=200)
    author = models.CharField(_('Author'), max_length=100)
    genre = models.CharField(_('Genre'), max_length=50)
    pages = models.PositiveIntegerField(_('Pages'), blank=True, null=True)
    description = models.TextField(_('Description'), blank=True, null=True)
    publication_date = models.DateField(_('Publication Date'), blank=True, null=True)
    is_currently_reading = models.BooleanField(_('Currently Reading'), default=False)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now=True)
    
    # User relationship - each book belongs to a user
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='books')
    
    class Meta:
        verbose_name = _('Book')
        verbose_name_plural = _('Books')
        ordering = ['-created_at']
        
    def __str__(self):
        return f"{self.title} by {self.author}"

class ReadingProgress(models.Model):
    """
    Model to track reading progress for a book
    """
    book = models.OneToOneField(Book, on_delete=models.CASCADE, related_name='reading_progress')
    current_page = models.PositiveIntegerField(_('Current Page'), default=0)
    start_date = models.DateField(_('Start Date'), blank=True, null=True)
    target_end_date = models.DateField(_('Target End Date'), blank=True, null=True)
    notes = models.TextField(_('Notes'), blank=True, null=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now=True)
    
    class Meta:
        verbose_name = _('Reading Progress')
        verbose_name_plural = _('Reading Progress')
        
    def __str__(self):
        return f"Progress for {self.book.title}"
    
    @property
    def percentage_complete(self):
        """Calculate percentage of book completed"""
        if not self.book.pages or self.book.pages == 0:
            return 0
        return min(100, int((self.current_page / self.book.pages) * 100))