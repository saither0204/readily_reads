from django.http import JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.db import connection

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    """
    Simple health check endpoint to verify the API is running
    and can connect to the database.
    """
    # Check database connection
    db_status = 'ok'
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            cursor.fetchone()
    except Exception:
        db_status = 'error'
    
    return JsonResponse({
        'status': 'ok',
        'database': db_status,
        'api_version': 'v1',
    })