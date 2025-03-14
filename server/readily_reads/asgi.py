"""
ASGI config for Readily Reads project.
"""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'readily_reads.settings')

application = get_asgi_application()