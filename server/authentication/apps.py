from django.apps import AppConfig

class AuthenticationConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'authentication'
    verbose_name = 'User Authentication'
    
    def ready(self):
        """
        Connect signals when the app is ready
        """
        import authentication.signals  # Import signals