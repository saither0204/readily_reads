from django.contrib import admin
from django.urls import path, include
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from django.conf import settings

# API Documentation schema
schema_view = get_schema_view(
    openapi.Info(
        title="Readily Reads API",
        default_version='v1',
        description="API for the Readily Reads book tracking application",
        contact=openapi.Contact(email="contact@readilyreads.example.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # API URLs
    path('api/auth/', include('authentication.urls')),
    path('api/books/', include('books.urls')),
    
    # API documentation
    path('api/docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('api/redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    
    # API health check
    path('health/', include('health_check.urls')),
]

# Admin site customization
admin.site.site_header = "Readily Reads Admin"
admin.site.site_title = "Readily Reads Admin Portal"
admin.site.index_title = "Welcome to Readily Reads Admin Portal"