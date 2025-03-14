from rest_framework import permissions

class IsBookOwner(permissions.BasePermission):
    """
    Custom permission to only allow owners of a book to view or edit it.
    """
    
    def has_object_permission(self, request, view, obj):
        # Permissions are only allowed to the owner of the book
        return obj.user == request.user