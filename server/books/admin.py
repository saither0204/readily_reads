from django.contrib import admin
from .models import Book, ReadingProgress

class ReadingProgressInline(admin.StackedInline):
    model = ReadingProgress
    extra = 0
    fields = ('current_page', 'start_date', 'target_end_date', 'notes')

@admin.register(Book)
class BookAdmin(admin.ModelAdmin):
    list_display = ('title', 'author', 'genre', 'user', 'is_currently_reading', 'created_at')
    list_filter = ('genre', 'is_currently_reading', 'created_at')
    search_fields = ('title', 'author', 'description')
    readonly_fields = ('created_at', 'updated_at')
    fieldsets = (
        (None, {
            'fields': ('title', 'author', 'user')
        }),
        ('Book Details', {
            'fields': ('genre', 'pages', 'description', 'publication_date')
        }),
        ('Status', {
            'fields': ('is_currently_reading',)
        }),
        ('Metadata', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
    inlines = [ReadingProgressInline]

@admin.register(ReadingProgress)
class ReadingProgressAdmin(admin.ModelAdmin):
    list_display = ('book', 'current_page', 'percentage_complete', 'start_date', 'target_end_date')
    list_filter = ('start_date', 'target_end_date')
    search_fields = ('book__title', 'book__author', 'notes')
    readonly_fields = ('percentage_complete', 'updated_at')
    fields = ('book', 'current_page', 'percentage_complete', 'start_date', 'target_end_date', 'notes', 'updated_at')