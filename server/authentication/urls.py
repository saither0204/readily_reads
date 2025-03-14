from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import RegisterView, UserProfileView

urlpatterns = [
    # JWT token endpoints
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Registration endpoint
    path('register/', RegisterView.as_view(), name='auth_register'),
    
    # User profile endpoint
    path('me/', UserProfileView.as_view(), name='user_profile'),
]